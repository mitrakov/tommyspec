// ignore_for_file: curly_braces_in_flow_control_structures
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tommyspec/common/icontextbutton.dart';
import 'package:tommyspec/given.dart';
import 'package:tommyspec/model/model.dart';
import 'package:tommyspec/then.dart';
import 'package:tommyspec/utils/fnctrl.dart';
import 'package:tommyspec/when.dart';

class ScenarioWidget extends StatefulWidget {
  final int idx;
  final FunctionController<String> runController;

  const ScenarioWidget(this.idx, this.runController);

  @override
  State<ScenarioWidget> createState() => _ScenarioWidgetState();
}

class _ScenarioWidgetState extends State<ScenarioWidget> {
  final cmdArgsCtrl = TextEditingController();
  final statusCtrl = TextEditingController();
  final stdoutCtrl = TextEditingController();
  final stderrCtrl = TextEditingController();
  bool showGiven = false;
  bool showWhen = false;
  bool showThen = false;

  @override
  void initState() {
    super.initState();
    widget.runController.register(runProcess);
  }

  @override
  Widget build(BuildContext context) {
    return Card(elevation: 5, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      showGiven ? GivenWidget(widget.idx) : TrixIconTextButton(icon: Icon(Icons.add_circle_outline_outlined), label: "Given", onTap: _onGivenPressed),
      showWhen ? WhenWidget(cmdArgsCtrl) : TrixIconTextButton(icon: Icon(Icons.add_circle_outline_outlined), label: "When", onTap: _onWhenPressed),
      showThen ? ThenWidget(statusCtrl: statusCtrl, stdoutCtrl: stdoutCtrl, stderrCtrl: stderrCtrl) : TrixIconTextButton(icon: Icon(Icons.add_circle_outline_outlined), label: "Then", onTap: _onThenPressed),
    ],),)
    ;
  }

  void _onGivenPressed() {
    setState(() {
      showGiven = !showGiven;
    });
  }

  void _onWhenPressed() {
    setState(() {
      showWhen = !showWhen;
    });
  }

  void _onThenPressed() {
    setState(() {
      showThen = !showThen;
    });
  }

  void runProcess(String command) {
    final model = ScopedModel.of<TestModel>(context);
    if (command.isNotEmpty) try {
      final args = cmdArgsCtrl.text.split(' ').where((a) => a.isNotEmpty).toList();
      final proc = Process.runSync(command, args, workingDirectory: model.getPwd(widget.idx), environment: model.getEnv(widget.idx));
      statusCtrl.text = proc.exitCode.toString();
      stdoutCtrl.text = proc.stdout;
      stderrCtrl.text = proc.stderr;
    } catch(e) {
      statusCtrl.text = "ERROR";
      stdoutCtrl.text = "";
      stderrCtrl.text = e.toString();
    }
  }
}
