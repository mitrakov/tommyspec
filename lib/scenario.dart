// ignore_for_file: curly_braces_in_flow_control_structures
import 'dart:convert';
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
            _showThen ? ThenWidget(i, actualStatusCtrl: statusCtrl, stdoutCtrl: stdoutCtrl, stderrCtrl: stderrCtrl) : TrixIconTextButton(icon: Icon(Icons.add_circle_outline_outlined), label: "Then", onTap: _onThenPressed),
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

  void runProcess(String command) async {
    final i = widget.idx;
    final model = ScopedModel.of<TestModel>(context);
    final workDir = model.getPwd(i);
    final env = model.getEnv(i);
    final args = model.getArgs(i);
    final input = model.getStdin(i);
    if (command.isNotEmpty) try {
      if (input.isEmpty) {
        final proc = Process.runSync(command, args, workingDirectory: workDir, environment: env);
        statusCtrl.text = proc.exitCode.toString();
        stdoutCtrl.text = proc.stdout;
        stderrCtrl.text = proc.stderr;
      } else {
        final proc = await Process.start(command, args, workingDirectory: workDir, environment: env);
        proc.stdin.add(utf8.encoder.convert(input));
        proc.stdin.close();
        statusCtrl.text = (await proc.exitCode).toString();
        stdoutCtrl.text = (await proc.stdout.transform(utf8.decoder).toList()).join('\n');
        stderrCtrl.text = (await proc.stderr.transform(utf8.decoder).toList()).join('\n');
      }
    } catch(e) {
      statusCtrl.text = "ERROR";
      stdoutCtrl.text = "";
      stderrCtrl.text = e.toString();
    }
  }
}
