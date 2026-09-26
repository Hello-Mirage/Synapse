import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

/// Service that communicates with the Google Gemini API.
///
/// Sends user prompts along with code context to Gemini, instructing it
/// to return structured JSON that maps to available skills.
class GeminiService {
  /// The Gemini API endpoint.
  static const String _apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  /// System prompt that instructs Gemini to return structured skill tasks.
  static const String _systemPrompt = '''
You are Synapse, an AI orchestration engine. Your job is to analyze user requests 
and convert them into executable skill tasks.

Available skills:
1. **code_generator** — Generate, edit, or create code files
   - Input: { "file_path": string, "code": string, "mode": "write"|"append"|"insert", "language": string }

2. **file_manager** — File system operations (read, list, delete, copy, move, exists, mkdir)
   - Input: { "operation": "read"|"list"|"delete"|"copy"|"move"|"exists"|"mkdir", "path": string, "destination"?: string, "recursive"?: bool, "pattern"?: string }

3. **shell_executor** — Execute shell commands
   - Input: { "command": string, "working_directory"?: string, "timeout_seconds"?: int }

4. **web_scraper** — Scrape web pages for text, links, or structured data
   - Input: { "url": string, "extract_mode": "text"|"links"|"selector"|"tables"|"html", "css_selector"?: string }

5. **api_caller** — Make HTTP API calls
   - Input: { "url": string, "method": "GET"|"POST"|"PUT"|"DELETE", "headers"?: object, "body"?: object, "query_params"?: object }

RULES:
- Analyze the user's request and determine which single skill best handles it.
- Return ONLY valid JSON in this exact format (no markdown, no explanation):
{
  "skill_name": "<skill_name>",
  "skill_input": { ... },
  "reasoning": "<brief explanation of why this skill was chosen>"
}
- If code context is provided, use it to make informed decisions about file paths and code content.
- For code generation tasks, write complete, production-quality code.
- For ambiguous requests, prefer the most specific applicable skill.
''';

  /// Call Gemini API with a user prompt and optional code context.
  ///
  /// Returns the raw Gemini response text, which should be valid JSON
  /// following the structured format defined in the system prompt.
  static Future<String> callGemini({
    required String prompt,
    String? codeContext,
    required String apiKey,
  }) async {
    // Build the user message
    final userMessage = StringBuffer();
    userMessage.writeln('USER REQUEST: $prompt');
    if (codeContext != null && codeContext.isNotEmpty) {
      userMessage.writeln('\nCODE CONTEXT:\n```\n$codeContext\n```');
    }

    final requestBody = jsonEncode({
      'system_instruction': {
        'parts': [
          {'text': _systemPrompt}
        ]
      },
      'contents': [
        {
          'parts': [
            {'text': userMessage.toString()}
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.2,
        'topP': 0.8,
        'maxOutputTokens': 8192,
        'responseMimeType': 'application/json',
      },
    });

    final url = Uri.parse('$_apiUrl?key=$apiKey');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Gemini API error (${response.statusCode}): ${response.body}',
      );
    }

    // Extract the text content from Gemini's response
    final responseData = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = responseData['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) {
      throw Exception('Gemini returned no candidates');
    }

    final content = candidates[0]['content'] as Map<String, dynamic>?;
    final parts = content?['parts'] as List<dynamic>?;
    if (parts == null || parts.isEmpty) {
      throw Exception('Gemini response has no content parts');
    }

    return parts[0]['text'] as String;
  }

  /// Parse Gemini's structured JSON response into skill name and input.
  static Map<String, dynamic> parseGeminiResponse(String responseText) {
    try {
      final parsed = jsonDecode(responseText) as Map<String, dynamic>;

      final skillName = parsed['skill_name'] as String?;
      final skillInput = parsed['skill_input'] as Map<String, dynamic>?;
      final reasoning = parsed['reasoning'] as String?;

      if (skillName == null || skillInput == null) {
        throw FormatException(
          'Missing required fields: skill_name or skill_input',
        );
      }

      return {
        'skill_name': skillName,
        'skill_input': skillInput,
        'reasoning': reasoning ?? '',
      };
    } catch (e) {
      throw FormatException(
        'Failed to parse Gemini response as structured JSON: $e\n'
        'Raw response: $responseText',
      );
    }
  }
}
