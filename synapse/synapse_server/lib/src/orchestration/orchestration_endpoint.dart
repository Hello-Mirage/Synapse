import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'gemini_service.dart';
import 'agent_service.dart';

/// Main orchestration endpoint.
///
/// Handles the full pipeline:
/// 1. Receive user prompt + code context
/// 2. Call Gemini API to get structured skill task
/// 3. Parse the response into skill name + input
/// 4. Dispatch to the Python agent service
/// 5. Return the result
class OrchestrationEndpoint extends Endpoint {
  final AgentService _agentService = AgentService();

  /// Execute a full orchestration: prompt → Gemini → skill → result.
  ///
  /// [prompt] - The user's instruction/request
  /// [codeContext] - Optional code to provide as context to Gemini
  ///
  /// Returns an [OrchestrationResponse] with the execution result.
  Future<OrchestrationResponse> orchestrate(
    Session session,
    String prompt,
    String? codeContext,
  ) async {
    final stopwatch = Stopwatch()..start();

    // Get API key from Serverpod passwords
    final apiKey = session.passwords['geminiApiKey'];
    if (apiKey == null || apiKey.isEmpty) {
      return OrchestrationResponse(
        status: 'failed',
        error:
            'Gemini API key not configured. Add "geminiApiKey" to your passwords.yaml',
      );
    }

    // Create task record in database
    final task = OrchestrationTask(
      prompt: prompt,
      codeContext: codeContext,
      status: 'calling_gemini',
      createdAt: DateTime.now(),
    );
    final taskRow = await OrchestrationTask.db.insertRow(session, task);

    try {
      // Step 1: Call Gemini API
      session.log('[${ taskRow.id }] Calling Gemini API...',
          level: LogLevel.info);

      final geminiResponse = await GeminiService.callGemini(
        prompt: prompt,
        codeContext: codeContext,
        apiKey: apiKey,
      );

      // Update task with Gemini response
      taskRow.geminiResponse = geminiResponse;
      taskRow.status = 'parsing';
      await OrchestrationTask.db.updateRow(session, taskRow);

      // Step 2: Parse Gemini response
      session.log('[${taskRow.id}] Parsing Gemini response...',
          level: LogLevel.info);

      final parsed = GeminiService.parseGeminiResponse(geminiResponse);
      final skillName = parsed['skill_name'] as String;
      final skillInput = parsed['skill_input'] as Map<String, dynamic>;

      taskRow.skillName = skillName;
      taskRow.skillInput = jsonEncode(skillInput);
      taskRow.status = 'dispatching';
      await OrchestrationTask.db.updateRow(session, taskRow);

      // Step 3: Dispatch to Python agent service
      session.log('[${taskRow.id}] Dispatching to skill: $skillName',
          level: LogLevel.info);

      taskRow.status = 'running';
      await OrchestrationTask.db.updateRow(session, taskRow);

      final result = await _agentService.executeSkill(
        taskId: taskRow.id.toString(),
        skillName: skillName,
        inputData: skillInput,
      );

      // Step 4: Process result
      final agentStatus = result['status'] as String?;
      final output = result['output'];
      final error = result['error'] as String?;

      if (agentStatus == 'complete') {
        taskRow.status = 'complete';
        taskRow.skillOutput = jsonEncode(output);
        taskRow.completedAt = DateTime.now();
        await OrchestrationTask.db.updateRow(session, taskRow);

        stopwatch.stop();
        session.log(
          '[${taskRow.id}] Orchestration complete in ${stopwatch.elapsedMilliseconds}ms',
          level: LogLevel.info,
        );

        return OrchestrationResponse(
          taskId: taskRow.id,
          status: 'complete',
          skillName: skillName,
          result: jsonEncode(output),
          executionTimeMs: stopwatch.elapsedMilliseconds,
        );
      } else {
        taskRow.status = 'failed';
        taskRow.errorMessage = error ?? 'Unknown agent error';
        taskRow.completedAt = DateTime.now();
        await OrchestrationTask.db.updateRow(session, taskRow);

        stopwatch.stop();
        return OrchestrationResponse(
          taskId: taskRow.id,
          status: 'failed',
          skillName: skillName,
          error: error ?? 'Skill execution failed',
          executionTimeMs: stopwatch.elapsedMilliseconds,
        );
      }
    } catch (e, stackTrace) {
      // Handle any errors in the pipeline
      taskRow.status = 'failed';
      taskRow.errorMessage = e.toString();
      taskRow.completedAt = DateTime.now();
      await OrchestrationTask.db.updateRow(session, taskRow);

      stopwatch.stop();
      session.log(
        '[${taskRow.id}] Orchestration failed: $e',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );

      return OrchestrationResponse(
        taskId: taskRow.id,
        status: 'failed',
        error: e.toString(),
        executionTimeMs: stopwatch.elapsedMilliseconds,
      );
    }
  }

  /// Get the status and details of a specific task.
  Future<OrchestrationTask?> getTask(Session session, int taskId) async {
    return await OrchestrationTask.db.findById(session, taskId);
  }

  /// List recent orchestration tasks.
  Future<List<OrchestrationTask>> listTasks(
    Session session,
    int limit,
    int offset,
  ) async {
    return await OrchestrationTask.db.find(
      session,
      orderBy: (t) => t.createdAt.desc(),
      limit: limit,
      offset: offset,
    );
  }
}
