// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:tommyspec/common/icontextbutton.dart';
import 'package:tommyspec/scenario.dart';
import 'package:tommyspec/utils/fnctrl.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Scaffold(body: MyApp())));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final commandCtrl = TextEditingController();
  final runCtrl = FunctionController<String>();
  int itemCount = 0;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: 50, child: Container(color: Colors.transparent, child: Row(children: [
        SizedBox(width: 300, child: TextField(controller: commandCtrl, decoration: InputDecoration(hintText: "Hey"))),
        OutlinedButton(child: Text("Run"), onPressed: () {
          setState(() { // TODO need this?
            runCtrl.run(commandCtrl.text.trim());
          });
        })
      ]))),
      Expanded(child: ListView.builder(
        itemCount: itemCount + 1,
        itemBuilder: (context, i) {
          return i == itemCount
            ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                TrixIconTextButton(icon: Icon(Icons.add_circle_outline), label: "Scenario", onTap: _addScenario)
              ],)
            : ScenarioWidget(runController: runCtrl,);
        }
      ))
    ]);
  }

  void _addScenario() {
    setState(() {
      itemCount++;
    });
  }
}
