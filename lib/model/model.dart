import 'package:scoped_model/scoped_model.dart';

class TommyModel extends Model {
  String _command = "";
  String? _pwd;
  Map<String, String>? _env;
  List<String> _args = [];
  String _expectedStatus = ""; // may be empty, that's why String (not int)
  List<AndModel> _ands = [];

  String get command => _command;
  String? get pwd => _pwd;
  Map<String, String>? get env => _env;
  String get envAsString => _env?.entries.map((e) => "${e.key}=${e.value}").join(';') ?? "";
  List<String> get args => _args;
  String get expectedStatus => _expectedStatus;
  List<AndModel> get ands => _ands;

  set command(String cmd) {
    _command = cmd.trim();
    notifyListeners();
  }

  set expectedStatus(String status) {
    _expectedStatus = status.trim();
    notifyListeners();
  }

  void setPwd(String pwd) {
    _pwd = pwd.trim().isEmpty ? null : pwd.trim();
    notifyListeners();
  }

  void setEnv(String env) {
    _env = env.trim().isEmpty ? null : Map.fromEntries(env.trim().split(';').where((l) => l.isNotEmpty).map((l) {
      final a = l.split('=');
      return MapEntry(a.first.trim(), a.last.trim());
    }));
    notifyListeners();
  }

  void setArgs(String args) {
    _args = args.trim().split(' ').where((a) => a.isNotEmpty).toList();
    notifyListeners();
  }

  void setAnds(List<AndModel> value) {
    _ands = value;
    notifyListeners();
  }
}

class AndModel {
  bool stdOutOrErr = true;
  String as = "CSV/Text";
  String query = "";
  String op = "=";
  String expected = "";
}
