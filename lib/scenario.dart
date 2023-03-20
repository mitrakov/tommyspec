// ignore_for_file: curly_braces_in_flow_control_structures, use_key_in_widget_constructors
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
  final FunctionController<TestModel> runController;

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
  late Key unsubscribeKey;

  @override
  void initState() {
    super.initState();
    final model = ScopedModel.of<TestModel>(context);
    final i = widget.idx;
    unsubscribeKey = widget.runController.register(runProcess); // register a function in parent, so that parent can call it
    _showGiven = model.getPwd(i) != null && model.getEnv(i) != null;
    _showWhen = model.getArgs(i).isNotEmpty;
    _showThen = model.getAndsCount(i) > 0;
  }

  @override
  void dispose() {
    widget.runController.deregister(unsubscribeKey); // unsubscribe the registered function, needed when a user removes the scenario
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final i = widget.idx;
    return ScopedModelDescendant<TestModel>(
      builder: (context, _, model) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column( mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _showGiven
                      ? GivenWidget(i)
                      : TrixIconTextButton(icon: const Icon(Icons.add_circle_outline_outlined), label: "Given", onTap: _onGivenPressed),
                    _showWhen
                      ? WhenWidget(i)
                      : TrixIconTextButton(icon: const Icon(Icons.add_circle_outline_outlined), label: "When", onTap: _onWhenPressed),
                    _showThen
                      ? ThenWidget(i, actualStatusCtrl: statusCtrl, stdoutCtrl: stdoutCtrl, stderrCtrl: stderrCtrl)
                      : TrixIconTextButton(icon: const Icon(Icons.add_circle_outline_outlined), label: "Then", onTap: _onThenPressed),
                  ])
                )
              ),
              Align(alignment: Alignment.topRight, child: IconButton(icon: const Icon(Icons.close), onPressed: () => model.removeScenario(i)))
            ]
          )
        );
      },
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

  void runProcess(TestModel model) async {
    final i = widget.idx;
    final command = model.command;
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
