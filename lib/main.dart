// ignore_for_file: use_key_in_widget_constructors
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:json_path/json_path.dart';
import 'package:split_view/split_view.dart';
import 'package:tommyspec/dropdown.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Scaffold(body: MyApp())));
}

class MyApp extends StatelessWidget {
  final commandCtrl = TextEditingController();
  final statusCtrl = TextEditingController();
  final stdoutCtrl = TextEditingController();
  final stderrCtrl = TextEditingController();
  final postProcessorCtrl = TextEditingController();
  final postProcessorResultCtrl = TextEditingController();
  final postProcessorExpectedCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: 50, child: Container(color: Colors.transparent, child: Row(children: [
        SizedBox(width: 300, child: TextFormField(controller: commandCtrl, decoration: InputDecoration(hintText: "Hey"))),
        OutlinedButton(child: Text("Run"), onPressed: () {
          _runProcess(commandCtrl.text, []);
        })
      ]))),
      TextField(controller: statusCtrl),
      Expanded(flex: 3, child: Container(color: Colors.grey, child: SplitView(viewMode: SplitViewMode.Horizontal, children: [
        TextFormField(controller: stdoutCtrl, maxLines: 4096),
        TextFormField(controller: stderrCtrl, maxLines: 4096),
      ]))),
      Row(children: [
        Expanded(child: TrixDropdown<String>(
          hintText: "Process",
          options: const ["Output", "Error"],
          getLabel: (String s) => s,
          onChanged: (s) {
            print(s);
          },
        )),
        Expanded(child: TrixDropdown<String>(
          hintText: "As",
          options: const ["Plain text", "Json", "XML", "Yaml"],
          getLabel: (String s) => s,
          onChanged: (s) {
            print(s);
          },
        )),
        Expanded(child: TextFormField(controller: postProcessorCtrl, decoration: InputDecoration(hintText: "Jmespath"))),
      ]),
      Expanded(child: Row(children: [
        Expanded(child: TextFormField(controller: postProcessorResultCtrl, maxLines: 1024)),
        Text("Should be"),
        Expanded(child: TrixDropdown<String>(
          hintText: "Op",
          options: const [">", "≥", "=", "<", "≤"],
          getLabel: (String s) => s,
          onChanged: (s) {
            print(s);
          },
        )),
        Expanded(child: TextField(controller: postProcessorExpectedCtrl)),
        postProcessorResultCtrl.text == postProcessorExpectedCtrl.text
          ? const Icon(Icons.done_rounded, color: Colors.green)
          : const Icon(Icons.do_not_disturb, color: Colors.red)
      ])),
    ]);
  }

  void _runProcess(String command, List<String> arguments) {
    final array = command.split(" ");
    if (array.isNotEmpty) {
      final proc = Process.runSync(array.first, array.sublist(1));
      statusCtrl.text = "ExitCode: ${proc.exitCode}";
      stdoutCtrl.text = proc.stdout;
      stderrCtrl.text = proc.stderr;
      _postProcess();
    }
  }

  void _postProcess() {
    final s = stdoutCtrl.text;
    final jmes = JsonPath("\$.${postProcessorCtrl.text}");
    final json = jsonDecode(s);
    final result = jmes.read(json).map((e) => e.value).first;
    postProcessorResultCtrl.text = result.toString();
  }
}
