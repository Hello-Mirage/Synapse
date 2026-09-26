import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'agent_service.dart';

/// Endpoint for querying available skills from the Python agent service.
class SkillEndpoint extends Endpoint {
  final AgentService _agentService = AgentService();

  /// List all available skills with their schemas.
  Future<List<SkillInfo>> listSkills(Session session) async {
    try {
      final rawSkills = await _agentService.listSkills();

      return rawSkills.map((s) {
        return SkillInfo(
          name: s['name'] as String? ?? 'unknown',
          description: s['description'] as String? ?? '',
          inputSchema: s['input_schema'] != null
              ? jsonEncode(s['input_schema'])
              : null,
        );
      }).toList();
    } catch (e) {
      session.log(
        'Failed to fetch skills from agent service: $e',
        level: LogLevel.error,
      );
      rethrow;
    }
  }

  /// Check the health of the Python agent service.
  Future<String> agentHealth(Session session) async {
    try {
      final health = await _agentService.healthCheck();
      return jsonEncode(health);
    } catch (e) {
      return jsonEncode({
        'status': 'unreachable',
        'error': e.toString(),
      });
    }
  }
}
