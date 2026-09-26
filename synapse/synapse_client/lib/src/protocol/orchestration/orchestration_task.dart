/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// Represents a user prompt and its orchestration through the system.
abstract class OrchestrationTask
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  OrchestrationTask._({
    this.id,
    required this.prompt,
    this.codeContext,
    this.geminiResponse,
    required this.status,
    this.skillName,
    this.skillInput,
    this.skillOutput,
    this.errorMessage,
    required this.createdAt,
    this.completedAt,
  });

  factory OrchestrationTask({
    int? id,
    required String prompt,
    String? codeContext,
    String? geminiResponse,
    required String status,
    String? skillName,
    String? skillInput,
    String? skillOutput,
    String? errorMessage,
    required DateTime createdAt,
    DateTime? completedAt,
  }) = _OrchestrationTaskImpl;

  factory OrchestrationTask.fromJson(Map<String, dynamic> jsonSerialization) {
    return OrchestrationTask(
      id: jsonSerialization['id'] as int?,
      prompt: jsonSerialization['prompt'] as String,
      codeContext: jsonSerialization['codeContext'] as String?,
      geminiResponse: jsonSerialization['geminiResponse'] as String?,
      status: jsonSerialization['status'] as String,
      skillName: jsonSerialization['skillName'] as String?,
      skillInput: jsonSerialization['skillInput'] as String?,
      skillOutput: jsonSerialization['skillOutput'] as String?,
      errorMessage: jsonSerialization['errorMessage'] as String?,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The user's original prompt/instruction.
  String prompt;

  /// Optional code context provided alongside the prompt.
  String? codeContext;

  /// Raw response from Gemini API.
  String? geminiResponse;

  /// Current status: pending, calling_gemini, parsing, dispatching, running, complete, failed.
  String status;

  /// Name of the skill selected for execution.
  String? skillName;

  /// JSON-encoded input data for the skill.
  String? skillInput;

  /// JSON-encoded output from the skill execution.
  String? skillOutput;

  /// Error message if the task failed.
  String? errorMessage;

  /// Timestamp when the task was created.
  DateTime createdAt;

  /// Timestamp when the task completed or failed.
  DateTime? completedAt;

  /// Returns a shallow copy of this [OrchestrationTask]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  OrchestrationTask copyWith({
    int? id,
    String? prompt,
    String? codeContext,
    String? geminiResponse,
    String? status,
    String? skillName,
    String? skillInput,
    String? skillOutput,
    String? errorMessage,
    DateTime? createdAt,
    DateTime? completedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrchestrationTask',
      if (id != null) 'id': id,
      'prompt': prompt,
      if (codeContext != null) 'codeContext': codeContext,
      if (geminiResponse != null) 'geminiResponse': geminiResponse,
      'status': status,
      if (skillName != null) 'skillName': skillName,
      if (skillInput != null) 'skillInput': skillInput,
      if (skillOutput != null) 'skillOutput': skillOutput,
      if (errorMessage != null) 'errorMessage': errorMessage,
      'createdAt': createdAt.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OrchestrationTask',
      if (id != null) 'id': id,
      'prompt': prompt,
      if (codeContext != null) 'codeContext': codeContext,
      if (geminiResponse != null) 'geminiResponse': geminiResponse,
      'status': status,
      if (skillName != null) 'skillName': skillName,
      if (skillInput != null) 'skillInput': skillInput,
      if (skillOutput != null) 'skillOutput': skillOutput,
      if (errorMessage != null) 'errorMessage': errorMessage,
      'createdAt': createdAt.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrchestrationTaskImpl extends OrchestrationTask {
  _OrchestrationTaskImpl({
    int? id,
    required String prompt,
    String? codeContext,
    String? geminiResponse,
    required String status,
    String? skillName,
    String? skillInput,
    String? skillOutput,
    String? errorMessage,
    required DateTime createdAt,
    DateTime? completedAt,
  }) : super._(
         id: id,
         prompt: prompt,
         codeContext: codeContext,
         geminiResponse: geminiResponse,
         status: status,
         skillName: skillName,
         skillInput: skillInput,
         skillOutput: skillOutput,
         errorMessage: errorMessage,
         createdAt: createdAt,
         completedAt: completedAt,
       );

  /// Returns a shallow copy of this [OrchestrationTask]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  OrchestrationTask copyWith({
    Object? id = _Undefined,
    String? prompt,
    Object? codeContext = _Undefined,
    Object? geminiResponse = _Undefined,
    String? status,
    Object? skillName = _Undefined,
    Object? skillInput = _Undefined,
    Object? skillOutput = _Undefined,
    Object? errorMessage = _Undefined,
    DateTime? createdAt,
    Object? completedAt = _Undefined,
  }) {
    return OrchestrationTask(
      id: id is int? ? id : this.id,
      prompt: prompt ?? this.prompt,
      codeContext: codeContext is String? ? codeContext : this.codeContext,
      geminiResponse: geminiResponse is String?
          ? geminiResponse
          : this.geminiResponse,
      status: status ?? this.status,
      skillName: skillName is String? ? skillName : this.skillName,
      skillInput: skillInput is String? ? skillInput : this.skillInput,
      skillOutput: skillOutput is String? ? skillOutput : this.skillOutput,
      errorMessage: errorMessage is String? ? errorMessage : this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
    );
  }
}
