/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:synapse_client/src/protocol/orchestration/orchestration_task.dart'
    as _i2jkxxt0;
import 'package:synapse_client/src/protocol/orchestration/skill_info.dart'
    as _irho2bto;
import 'greetings/greeting.dart' as _izw8z7ou;
import 'orchestration/orchestration_response.dart' as _ihflqyh1;
import 'orchestration/orchestration_task.dart' as _iga6oxvj;
import 'orchestration/skill_info.dart' as _ip4lorut;
export 'greetings/greeting.dart';
export 'orchestration/orchestration_response.dart';
export 'orchestration/orchestration_task.dart';
export 'orchestration/skill_info.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _izw8z7ou.Greeting) {
      return _izw8z7ou.Greeting.fromJson(data) as T;
    }
    if (t == _ihflqyh1.OrchestrationResponse) {
      return _ihflqyh1.OrchestrationResponse.fromJson(data) as T;
    }
    if (t == _iga6oxvj.OrchestrationTask) {
      return _iga6oxvj.OrchestrationTask.fromJson(data) as T;
    }
    if (t == _ip4lorut.SkillInfo) {
      return _ip4lorut.SkillInfo.fromJson(data) as T;
    }
    if (t == _isc.getType<_izw8z7ou.Greeting?>()) {
      return (data != null ? _izw8z7ou.Greeting.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ihflqyh1.OrchestrationResponse?>()) {
      return (data != null
              ? _ihflqyh1.OrchestrationResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iga6oxvj.OrchestrationTask?>()) {
      return (data != null ? _iga6oxvj.OrchestrationTask.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ip4lorut.SkillInfo?>()) {
      return (data != null ? _ip4lorut.SkillInfo.fromJson(data) : null) as T;
    }
    if (t == List<_i2jkxxt0.OrchestrationTask>) {
      return (data as List)
              .map((e) => deserialize<_i2jkxxt0.OrchestrationTask>(e))
              .toList()
          as T;
    }
    if (t == List<_irho2bto.SkillInfo>) {
      return (data as List)
              .map((e) => deserialize<_irho2bto.SkillInfo>(e))
              .toList()
          as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _izw8z7ou.Greeting => 'Greeting',
      _ihflqyh1.OrchestrationResponse => 'OrchestrationResponse',
      _iga6oxvj.OrchestrationTask => 'OrchestrationTask',
      _ip4lorut.SkillInfo => 'SkillInfo',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('synapse.', '');
    }

    switch (data) {
      case _izw8z7ou.Greeting():
        return 'Greeting';
      case _ihflqyh1.OrchestrationResponse():
        return 'OrchestrationResponse';
      case _iga6oxvj.OrchestrationTask():
        return 'OrchestrationTask';
      case _ip4lorut.SkillInfo():
        return 'SkillInfo';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_izw8z7ou.Greeting>(data['data']);
    }
    if (dataClassName == 'OrchestrationResponse') {
      return deserialize<_ihflqyh1.OrchestrationResponse>(data['data']);
    }
    if (dataClassName == 'OrchestrationTask') {
      return deserialize<_iga6oxvj.OrchestrationTask>(data['data']);
    }
    if (dataClassName == 'SkillInfo') {
      return deserialize<_ip4lorut.SkillInfo>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('synapse', this);
    _iacc.Protocol().registerHostProtocol('synapse', this);
  }

  @override
  String getModuleName() => 'synapse';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
