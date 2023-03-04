import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tommyspec/common/icontextbutton.dart';
import 'package:tommyspec/given.dart';
import 'package:tommyspec/then.dart';
import 'package:tommyspec/utils/fnctrl.dart';
import 'package:tommyspec/when.dart';

class ScenarioWidget extends StatefulWidget {
  final FunctionController<String> runController;
  const ScenarioWidget({super.key, required this.runController});

  @override
  State<ScenarioWidget> createState() => _ScenarioWidgetState();
}

class _ScenarioWidgetState extends State<ScenarioWidget> {
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
      showGiven ? GivenWidget() : TrixIconTextButton(icon: Icon(Icons.add_circle_outline_outlined), label: "Given", onTap: _onGivenPressed),
      showWhen ? WhenWidget() : TrixIconTextButton(icon: Icon(Icons.add_circle_outline_outlined), label: "When", onTap: _onWhenPressed),
      showThen ? ThenWidget(stdoutCtrl: stdoutCtrl, stderrCtrl: stderrCtrl) : TrixIconTextButton(icon: Icon(Icons.add_circle_outline_outlined), label: "Then", onTap: _onThenPressed),
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
    final array = command.split(" ");
    if (array.isNotEmpty) {
      final proc = Process.runSync(array.first, array.sublist(1));
      print(proc.exitCode);
      stdoutCtrl.text = proc.stdout;
      stderrCtrl.text = proc.stderr;
    }
  }
}
