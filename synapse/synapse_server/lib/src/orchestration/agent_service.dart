import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

/// Service that communicates with the Python Agent Service.
///
/// Dispatches skill execution tasks and retrieves available skill info.
class AgentService {
  /// Base URL of the Python agent service.
  final String baseUrl;

  AgentService({this.baseUrl = 'http://localhost:8090'});

  /// Execute a skill on the Python agent service.
  ///
  /// [taskId] - Unique task identifier
  /// [skillName] - Name of the skill to execute
  /// [inputData] - Input parameters for the skill
  /// [timeoutSeconds] - Max execution time
  ///
  /// Returns the execution result as a Map.
  Future<Map<String, dynamic>> executeSkill({
    required String taskId,
    required String skillName,
    required Map<String, dynamic> inputData,
    int timeoutSeconds = 120,
  }) async {
    final url = Uri.parse('$baseUrl/execute');

    final requestBody = jsonEncode({
      'task_id': taskId,
      'skill_name': skillName,
      'input_data': inputData,
      'timeout_seconds': timeoutSeconds,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Agent service error (${response.statusCode}): ${response.body}',
      );
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Get list of all available skills from the agent service.
  Future<List<Map<String, dynamic>>> listSkills() async {
    final url = Uri.parse('$baseUrl/skills');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception(
        'Agent service error (${response.statusCode}): ${response.body}',
      );
    }

    final list = jsonDecode(response.body) as List<dynamic>;
    return list.cast<Map<String, dynamic>>();
  }

  /// Check if the agent service is healthy.
  Future<Map<String, dynamic>> healthCheck() async {
    final url = Uri.parse('$baseUrl/health');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception(
        'Agent service unreachable (${response.statusCode}): ${response.body}',
      );
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
