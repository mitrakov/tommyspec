// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TestModel _$TestModelFromJson(Map<String, dynamic> json) => TestModel()
  ..command = json['command'] as String
  ..scenarios = (json['scenarios'] as List<dynamic>)
      .map((e) => ScenarioModel.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$TestModelToJson(TestModel instance) => <String, dynamic>{
      'command': instance.command,
      'scenarios': instance.scenarios.map((e) => e.toJson()).toList(),
    };

ScenarioModel _$ScenarioModelFromJson(Map<String, dynamic> json) =>
    ScenarioModel()
      ..pwd = json['pwd'] as String?
      ..env = (json['env'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      )
      ..args = (json['args'] as List<dynamic>).map((e) => e as String).toList()
      ..stdin = json['stdin'] as String
      ..expectedStatus = json['expectedStatus'] as String
      ..ands = (json['ands'] as List<dynamic>)
          .map((e) => AndModel.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ScenarioModelToJson(ScenarioModel instance) =>
    <String, dynamic>{
      'pwd': instance.pwd,
      'env': instance.env,
      'args': instance.args,
      'stdin': instance.stdin,
      'expectedStatus': instance.expectedStatus,
      'ands': instance.ands.map((e) => e.toJson()).toList(),
    };

AndModel _$AndModelFromJson(Map<String, dynamic> json) => AndModel()
  ..stdOutOrErr = json['stdOutOrErr'] as bool
  ..as = json['as'] as String
  ..query = json['query'] as String
  ..op = json['op'] as String
  ..expected = json['expected'] as String;

Map<String, dynamic> _$AndModelToJson(AndModel instance) => <String, dynamic>{
      'stdOutOrErr': instance.stdOutOrErr,
      'as': instance.as,
      'query': instance.query,
      'op': instance.op,
      'expected': instance.expected,
    };
