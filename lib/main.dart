// ignore_for_file: use_key_in_widget_constructors
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:split_view/split_view.dart';
import 'package:tommyspec/and.dart';
import 'package:tommyspec/expand.dart';

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
    return Column(children: [
      SizedBox(height: 50, child: Container(color: Colors.transparent, child: Row(children: [
        SizedBox(width: 300, child: TextFormField(controller: commandCtrl, decoration: InputDecoration(hintText: "Hey"))),
        OutlinedButton(child: Text("Run"), onPressed: () {
          setState(() {
            _runProcess(commandCtrl.text, []);
          });
        })
      ]))),
      TextField(controller: statusCtrl),
      TrixExpandPanel(headerWidget: Text("Output"), child: Container(height: 200, color: Colors.grey, child: SplitView(viewMode: SplitViewMode.Horizontal, children: [
        TextFormField(controller: stdoutCtrl, maxLines: 4096),
        TextFormField(controller: stderrCtrl, maxLines: 4096),
      ]))),
      Expanded(child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, i) {
          return AndWidget(stdoutCtrl: stdoutCtrl, stderrCtrl: stderrCtrl);
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
