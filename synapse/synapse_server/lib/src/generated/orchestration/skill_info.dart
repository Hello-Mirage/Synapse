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
import 'package:serverpod/serverpod.dart' as _is;

/// Information about an available skill in the Python agent service.
abstract class SkillInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SkillInfo._({
    required this.name,
    required this.description,
    this.inputSchema,
  });

  factory SkillInfo({
    required String name,
    required String description,
    String? inputSchema,
  }) = _SkillInfoImpl;

  factory SkillInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return SkillInfo(
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      inputSchema: jsonSerialization['inputSchema'] as String?,
    );
  }

  /// Unique skill identifier.
  String name;

  /// Human-readable description of the skill.
  String description;

  /// JSON-encoded schema of expected inputs.
  String? inputSchema;

  /// Returns a shallow copy of this [SkillInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SkillInfo copyWith({
    String? name,
    String? description,
    String? inputSchema,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SkillInfo',
      'name': name,
      'description': description,
      if (inputSchema != null) 'inputSchema': inputSchema,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SkillInfo',
      'name': name,
      'description': description,
      if (inputSchema != null) 'inputSchema': inputSchema,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SkillInfoImpl extends SkillInfo {
  _SkillInfoImpl({
    required String name,
    required String description,
    String? inputSchema,
  }) : super._(
         name: name,
         description: description,
         inputSchema: inputSchema,
       );

  /// Returns a shallow copy of this [SkillInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SkillInfo copyWith({
    String? name,
    String? description,
    Object? inputSchema = _Undefined,
  }) {
    return SkillInfo(
      name: name ?? this.name,
      description: description ?? this.description,
      inputSchema: inputSchema is String? ? inputSchema : this.inputSchema,
    );
  }
}
