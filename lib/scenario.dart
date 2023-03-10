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
  final statusCtrl = TextEditingController();
  final stdoutCtrl = TextEditingController();
  final stderrCtrl = TextEditingController();
  bool _showGiven = false;
  bool _showWhen = false;
  bool _showThen = false;
  bool _isDeleted = false;

  @override
  void initState() {
    super.initState();
    widget.runController.register(runProcess);
    final model = ScopedModel.of<TestModel>(context);
    final i = widget.idx;
    _showGiven = model.getPwd(i) != null && model.getEnv(i) != null;
    _showWhen = model.getArgs(i).isNotEmpty;
    _showThen = model.getAndsCount(i) > 0;
  }

  @override
  Widget build(BuildContext context) {
    final i = widget.idx;
    return Visibility(
      visible: !_isDeleted,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Card(elevation: 5, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            _showGiven ? GivenWidget(i) : TrixIconTextButton(icon: Icon(Icons.add_circle_outline_outlined), label: "Given", onTap: _onGivenPressed),
            _showWhen ? WhenWidget(i) : TrixIconTextButton(icon: Icon(Icons.add_circle_outline_outlined), label: "When", onTap: _onWhenPressed),
            _showThen ? ThenWidget(i, statusCtrl: statusCtrl, stdoutCtrl: stdoutCtrl, stderrCtrl: stderrCtrl) : TrixIconTextButton(icon: Icon(Icons.add_circle_outline_outlined), label: "Then", onTap: _onThenPressed),
          ])),
          Align(alignment: Alignment.topRight, child: IconButton(icon: Icon(Icons.close), onPressed: _delete))
        ],
      ),
    );
  }

  void _onGivenPressed() {
    setState(() {
      _showGiven = !_showGiven;
    });
  }

  void _onWhenPressed() {
    setState(() {
      _showWhen = !_showWhen;
    });
  }

  void _onThenPressed() {
    setState(() {
      _showThen = !_showThen;
    });
  }

  void _delete() {
    setState(() {
      _isDeleted = true;
    });
  }

  void runProcess(String command) {
    final model = ScopedModel.of<TestModel>(context);
    if (command.isNotEmpty) try {
      final args = model.getArgs(widget.idx);
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
