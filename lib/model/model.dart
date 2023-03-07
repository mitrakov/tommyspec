import 'package:scoped_model/scoped_model.dart';

class TestModel extends Model {
  String _command = "";
  final List<_ScenarioModel> _scenarios = [];

  // getters
  String get command => _command;

  int get scenariosCount => _scenarios.length;

  int getAndsCount(int scenario) => _scenarios[scenario].ands.length;

  String? getPwd(int scenario) => _scenarios[scenario].pwd;
  
  Map<String, String>? getEnv(int scenario) => _scenarios[scenario].env;
  
  String getEnvAsString(int scenario) => _scenarios[scenario].env?.entries.map((e) => "${e.key}=${e.value}").join(';') ?? "";

  List<String> getArgs(int scenario) => _scenarios[scenario].args;

  String getArgsAsString(int scenario) => _scenarios[scenario].args.join(' ');

  String getStatus(int scenario) => _scenarios[scenario].expectedStatus;

  bool stdOutOrErr(int scenario, int and) => _scenarios[scenario].ands[and].stdOutOrErr;

  String as(int scenario, int and) => _scenarios[scenario].ands[and].as;

  String query(int scenario, int and) => _scenarios[scenario].ands[and].query;

  String op(int scenario, int and) => _scenarios[scenario].ands[and].op;

  String expected(int scenario, int and) => _scenarios[scenario].ands[and].expected;

  // setters
  set command(String cmd) {
    _command = cmd.trim();
    notifyListeners();
  }

  void setExpectedStatus(int scenario, String status) {
    _scenarios[scenario].expectedStatus = status.trim();
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
    _scenarios.add(_ScenarioModel());
    notifyListeners();
  }

  void addAndCondition(int scenario) {
    _scenarios[scenario].ands.add(_AndModel());
    notifyListeners();
  }
}

class _ScenarioModel {
  String? pwd;
  Map<String, String>? env;
  List<String> args = [];
  String expectedStatus = ""; // may be empty, that's why String (not int)
  List<_AndModel> ands = [];
}

class _AndModel {
  bool stdOutOrErr = true;
  String as = "CSV/Text";
  String query = "";
  String op = "=";
  String expected = "";
}
