// ignore_for_file: use_key_in_widget_constructors
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tommyspec/common/icontextbutton.dart';
import 'package:tommyspec/model/model.dart';
import 'package:tommyspec/scenario.dart';
import 'package:tommyspec/utils/fnctrl.dart';

void main() {
  final model = TestModel();
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Scaffold(body: ScopedModel(model: model, child: MyApp()))));
}

class MyApp extends StatefulWidget {    // TODO: stateless?
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final runCtrl = FunctionController<String>();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TestModel>(
        builder: (context, _, model) {
        return PlatformMenuBar(
          menus: [
            PlatformMenu(label: "Hey-Hey", menus: [
              PlatformMenuItem(label: "Quit", shortcut: const SingleActivator(LogicalKeyboardKey.keyQ, meta: true), onSelected: () => exit(0))
            ]),
            PlatformMenu(label: "File", menus: [
              PlatformMenuItem(label: "Load", shortcut: SingleActivator(LogicalKeyboardKey.keyO, meta: true), onSelected: () => _openFile()),
              PlatformMenuItem(label: "Save", shortcut: SingleActivator(LogicalKeyboardKey.keyS, meta: true), onSelected: () => _saveFile(model))
            ])
          ],
          child: Shortcuts(
            shortcuts: {
              SingleActivator(LogicalKeyboardKey.enter): RunIntent() // move to menu?
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
                    itemCount: model.scenariosCount + 1,
                    itemBuilder: (context, i) {
                      return i == model.scenariosCount
                          ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        TrixIconTextButton(icon: Icon(Icons.add_circle_outline), label: "Scenario", onTap: () => model.addScenario())
                      ],)
                          : ScenarioWidget(i, runCtrl);
                    }
                ))
              ])
            )
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

  void _saveFile(TestModel model) async {
    final filePath = await FilePicker.platform.saveFile(dialogTitle: "Save file", fileName: "test.json", allowedExtensions: ["json"], lockParentWindow: true);
    if (filePath != null) { // user may cancel
      // TODO: check on Windows "if file exists" (on MacOS norm)
      File(filePath).writeAsString(jsonEncode(model.toJson()), flush: true);
    }
  }

  void _openFile() async {
    final result = await FilePicker.platform.pickFiles(dialogTitle: "Open file", type: FileType.custom, allowedExtensions: ["json"], withData: true, lockParentWindow: true);
    if (result != null) { // user may cancel
      final bytes = result.files.first.bytes!; // may be null?
      final str = Utf8Decoder().convert(bytes);
      final json = jsonDecode(str);
      final model = TestModel.fromJson(json);
      print(model.command);
    }
  }
}

class RunIntent extends Intent {}
