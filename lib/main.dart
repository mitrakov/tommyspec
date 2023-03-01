// ignore_for_file: use_key_in_widget_constructors
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tommyspec/common/expand.dart';
import 'package:tommyspec/given.dart';
import 'package:tommyspec/when.dart';
import 'package:tommyspec/then.dart';

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
      GivenWidget(),
      WhenWidget(),
      Expanded(child: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, i) {
          return TrixExpandPanel(headerWidget: Text("THEN"), child: ThenWidget(stdoutCtrl: stdoutCtrl, stderrCtrl: stderrCtrl));
        }
      ))
    ]);
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
