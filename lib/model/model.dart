import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:scoped_model/scoped_model.dart';
part 'model.g.dart';

@JsonSerializable(explicitToJson: true)
class TestModel extends Model {
  int _createdTs = DateTime.now().millisecondsSinceEpoch; // needed to hard reset model and rebuild the whole widget tree
  String _command = "";
  List<ScenarioModel> _scenarios = [];

  TestModel();

  // getters
  int get createdTs => _createdTs;

  String get command => _command;

  int get scenariosCount => _scenarios.length;

  int getAndsCount(int scenario) => _scenarios[scenario].ands.length;

  String? getPwd(int scenario) => _scenarios[scenario].pwd;
  
  Map<String, String>? getEnv(int scenario) => _scenarios[scenario].env;
  
  String getEnvAsString(int scenario) => _scenarios[scenario].env?.entries.map((e) => "${e.key}=${e.value}").join(';') ?? "";

  List<String> getArgs(int scenario) => _scenarios[scenario].args;

  String getStdin(int scenario) => _scenarios[scenario].stdin;

  String getArgsAsString(int scenario) => _scenarios[scenario].args.join(' ');

  String getExpectedStatus(int scenario) => _scenarios[scenario].expectedStatus;

  bool getStdOutOrErr(int scenario, int and) => _scenarios[scenario].ands[and].stdOutOrErr;

  String getAs(int scenario, int and) => _scenarios[scenario].ands[and].as;

  String getQuery(int scenario, int and) => _scenarios[scenario].ands[and].query;

  String getOperation(int scenario, int and) => _scenarios[scenario].ands[and].op;

  String getExpectedValue(int scenario, int and) => _scenarios[scenario].ands[and].expected;

  // setters
  set command(String cmd) {
    _command = cmd.trim();
    notifyListeners();
  }

  void setWorkingDirectory(int scenario, String pwd) {
    _scenarios[scenario].pwd = pwd.trim().isEmpty ? null : pwd.trim();
    notifyListeners();
  }

  void setEnv(int scenario, String env) {
    _scenarios[scenario].env = env.trim().isEmpty ? null : Map.fromEntries(env.trim().split(';').where((l) => l.isNotEmpty).map((l) {
      final a = l.split('=');
      return MapEntry(a.first.trim(), a.last.trim());
    }));
    notifyListeners();
  }

  void setArgs(int scenario, String args) {
    _scenarios[scenario].args = args.trim().split(' ').where((a) => a.isNotEmpty).toList();
    notifyListeners();
  }

  void setStdIn(int scenario, String input) {
    _scenarios[scenario].stdin = input.trim();
    notifyListeners();
  }

  void setExpectedStatus(int scenario, String status) {
    _scenarios[scenario].expectedStatus = status.trim();
    notifyListeners();
  }

  void setStdOutOrErr(int scenario, int and, bool stdOutOrErr) {
    _scenarios[scenario].ands[and].stdOutOrErr = stdOutOrErr;
    notifyListeners();
  }

  void setAs(int scenario, int and, String as) {
    _scenarios[scenario].ands[and].as = as;
    notifyListeners();
  }

  void setQuery(int scenario, int and, String query) {
    _scenarios[scenario].ands[and].query = query;
    notifyListeners();
  }

  void setOperation(int scenario, int and, String op) {
    _scenarios[scenario].ands[and].op = op;
    notifyListeners();
  }

  void setExpectedValue(int scenario, int and, String expected) {
    _scenarios[scenario].ands[and].expected = expected;
    notifyListeners();
  }

  // adders
  void addScenario() {
    _scenarios.add(ScenarioModel());
    notifyListeners();
  }

  void addAndCondition(int scenario) {
    _scenarios[scenario].ands.add(AndModel());
    notifyListeners();
  }

  // removers
  void removeScenario(int scenario) {
    _scenarios.removeAt(scenario);
    _createdTs = DateTime.now().millisecondsSinceEpoch; // hard reset model
    notifyListeners();
  }

  void removeAnd(int scenario, int and) {
    _scenarios[scenario].ands.removeAt(and);
    _createdTs = DateTime.now().millisecondsSinceEpoch; // hard reset model
    notifyListeners();
  }

  // json serialization
  @protected // used only for json generation
  List<ScenarioModel> get scenarios => _scenarios;

  @protected // used only for json generation
  set scenarios(List<ScenarioModel> list) {
    _scenarios = list;
  }

  factory TestModel.fromJson(Map<String, dynamic> json) => _$TestModelFromJson(json);
  Map<String, dynamic> toJson() => _$TestModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ScenarioModel {
  String? pwd;
  Map<String, String>? env;
  List<String> args = [];
  String stdin = "";
  String expectedStatus = ""; // may be empty, that's why String (not int)
  List<AndModel> ands = [];

  ScenarioModel();

  factory ScenarioModel.fromJson(Map<String, dynamic> json) => _$ScenarioModelFromJson(json);
  Map<String, dynamic> toJson() => _$ScenarioModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AndModel {
  bool stdOutOrErr = true;
  String as = "CSV/Text";
  String query = "";
  String op = "=";
  String expected = "";

  AndModel();

  factory AndModel.fromJson(Map<String, dynamic> json) => _$AndModelFromJson(json);
  Map<String, dynamic> toJson() => _$AndModelToJson(this);
}
