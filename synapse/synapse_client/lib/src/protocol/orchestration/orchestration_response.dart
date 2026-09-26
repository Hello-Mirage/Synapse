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

/// Response from an orchestration request.
abstract class OrchestrationResponse
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  OrchestrationResponse._({
    this.taskId,
    required this.status,
    this.skillName,
    this.result,
    this.error,
    this.executionTimeMs,
  });

  factory OrchestrationResponse({
    int? taskId,
    required String status,
    String? skillName,
    String? result,
    String? error,
    int? executionTimeMs,
  }) = _OrchestrationResponseImpl;

  factory OrchestrationResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return OrchestrationResponse(
      taskId: jsonSerialization['taskId'] as int?,
      status: jsonSerialization['status'] as String,
      skillName: jsonSerialization['skillName'] as String?,
      result: jsonSerialization['result'] as String?,
      error: jsonSerialization['error'] as String?,
      executionTimeMs: jsonSerialization['executionTimeMs'] as int?,
    );
  }

  /// The task ID assigned to this orchestration.
  int? taskId;

  /// Current status of the task.
  String status;

  /// The skill name that was selected.
  String? skillName;

  /// JSON-encoded result from the skill execution.
  String? result;

  /// Error message if something went wrong.
  String? error;

  /// How long the full orchestration took in milliseconds.
  int? executionTimeMs;

  /// Returns a shallow copy of this [OrchestrationResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  OrchestrationResponse copyWith({
    int? taskId,
    String? status,
    String? skillName,
    String? result,
    String? error,
    int? executionTimeMs,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrchestrationResponse',
      if (taskId != null) 'taskId': taskId,
      'status': status,
      if (skillName != null) 'skillName': skillName,
      if (result != null) 'result': result,
      if (error != null) 'error': error,
      if (executionTimeMs != null) 'executionTimeMs': executionTimeMs,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OrchestrationResponse',
      if (taskId != null) 'taskId': taskId,
      'status': status,
      if (skillName != null) 'skillName': skillName,
      if (result != null) 'result': result,
      if (error != null) 'error': error,
      if (executionTimeMs != null) 'executionTimeMs': executionTimeMs,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrchestrationResponseImpl extends OrchestrationResponse {
  _OrchestrationResponseImpl({
    int? taskId,
    required String status,
    String? skillName,
    String? result,
    String? error,
    int? executionTimeMs,
  }) : super._(
         taskId: taskId,
         status: status,
         skillName: skillName,
         result: result,
         error: error,
         executionTimeMs: executionTimeMs,
       );

  /// Returns a shallow copy of this [OrchestrationResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  OrchestrationResponse copyWith({
    Object? taskId = _Undefined,
    String? status,
    Object? skillName = _Undefined,
    Object? result = _Undefined,
    Object? error = _Undefined,
    Object? executionTimeMs = _Undefined,
  }) {
    return OrchestrationResponse(
      taskId: taskId is int? ? taskId : this.taskId,
      status: status ?? this.status,
      skillName: skillName is String? ? skillName : this.skillName,
      result: result is String? ? result : this.result,
      error: error is String? ? error : this.error,
      executionTimeMs: executionTimeMs is int?
          ? executionTimeMs
          : this.executionTimeMs,
    );
  }
}
