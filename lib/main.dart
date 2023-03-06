// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tommyspec/common/icontextbutton.dart';
import 'package:tommyspec/model/model.dart';
import 'package:tommyspec/scenario.dart';
import 'package:tommyspec/utils/fnctrl.dart';

void main() {
  final model = TommyModel();
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Scaffold(body: ScopedModel(model: model, child: MyApp()))));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final runCtrl = FunctionController<String>();
  int itemCount = 0;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TommyModel>(
        builder: (context, _, model) {
        return Shortcuts(
          shortcuts: {
            SingleActivator(LogicalKeyboardKey.enter): RunIntent()
          },
          child: Actions(
            actions: {
              RunIntent: CallbackAction(onInvoke: (_) => _run(model.command))
            },
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: 50, child: Container(color: Colors.transparent, child: Row(children: [
                SizedBox(
                  width: 300,
                  child: TextFormField(initialValue: model.command, decoration: InputDecoration(hintText: "Command"), onChanged: (s) => model.command = s)
                ),
                OutlinedButton(child: Text("Run"), onPressed: () => _run(model.command))
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
            ])
          )
        );
      }
    );
  }

  void _run(String command) {
    setState(() { // we need this to update children
      runCtrl.run(command);
    });
  }

  void _addScenario() {
    setState(() {
      itemCount++;
    });
  }
}

class RunIntent extends Intent {}
