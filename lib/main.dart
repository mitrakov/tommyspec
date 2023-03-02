// ignore_for_file: use_key_in_widget_constructors
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tommyspec/common/icontextbutton.dart';
import 'package:tommyspec/scenario.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Scaffold(body: MyApp())));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final commandCtrl = TextEditingController();
  final statusCtrl = TextEditingController();
  final stdoutCtrl = TextEditingController();
  final stderrCtrl = TextEditingController();
  int itemCount = 0;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: 50, child: Container(color: Colors.transparent, child: Row(children: [
        SizedBox(width: 300, child: TextField(controller: commandCtrl, decoration: InputDecoration(hintText: "Hey"))),
        OutlinedButton(child: Text("Run"), onPressed: () {
          setState(() {
            _runProcess(commandCtrl.text, []);
          });
        })
      ]))),
      TextField(controller: statusCtrl),
      Expanded(child: ListView.builder(
        itemCount: itemCount + 1,
        itemBuilder: (context, i) {
          return i == itemCount
            ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                TrixIconTextButton(icon: Icon(Icons.add_circle_outline), label: "Scenario", onTap: _addScenario)
              ],)
            : ScenarioWidget(stdoutCtrl: stdoutCtrl, stderrCtrl: stderrCtrl,);
        }
      ))
    ]);
  }

  void _addScenario() {
    setState(() {
      itemCount++;
    });
  }

  void _runProcess(String command, List<String> arguments) {
    final array = command.split(" ");
    if (array.isNotEmpty) {
      final proc = Process.runSync(array.first, array.sublist(1));
      statusCtrl.text = "ExitCode: ${proc.exitCode}";
      stdoutCtrl.text = proc.stdout;
      stderrCtrl.text = proc.stderr;
    }
  }
}
