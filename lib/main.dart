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
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Scaffold(body: MyApp())));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final runCtrl = FunctionController<String>();
  final commandController = TextEditingController();
  TestModel _model = TestModel();

  @override
  Widget build(BuildContext context) {
    commandController.text = _model.command;
    return ScopedModel<TestModel>(
      model: _model,
      child: PlatformMenuBar(
          menus: [
            PlatformMenu(label: "Hey-Hey", menus: [
              PlatformMenuItem(label: "Quit", shortcut: const SingleActivator(LogicalKeyboardKey.keyQ, meta: true), onSelected: () => exit(0))
            ]),
            PlatformMenu(label: "File", menus: [
              PlatformMenuItem(label: "Open", shortcut: SingleActivator(LogicalKeyboardKey.keyO, meta: true), onSelected: _openFile),
              PlatformMenuItem(label: "Save", shortcut: SingleActivator(LogicalKeyboardKey.keyS, meta: true), onSelected: _saveFile)
            ])
          ],
          child: Shortcuts(
              shortcuts: {
                SingleActivator(LogicalKeyboardKey.enter): RunIntent() // move to menu?
              },
              child: Actions(
                  actions: {
                    RunIntent: CallbackAction(onInvoke: (_) => _run(_model.command))
                  },
                  child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(height: 50, child: Container(color: Colors.transparent, child: Row(children: [
                      SizedBox(
                          width: 300,
                          child: TextField(controller: commandController, decoration: InputDecoration(hintText: "Command"), onChanged: (s) => _model.command = s)
                      ),
                      OutlinedButton(child: Text("Run"), onPressed: () => _run(_model.command))
                    ]))),
                    Expanded(child: ListView.builder(
                        itemCount: _model.scenariosCount + 1,
                        itemBuilder: (context, i) {
                          return i == _model.scenariosCount
                              ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            TrixIconTextButton(icon: Icon(Icons.add_circle_outline), label: "Scenario", onTap: () => _model.addScenario())
                          ],)
                              : ScenarioWidget(i, runCtrl);
                        }
                    ))
                  ])
              )
          )
      )
    );
  }

  void _run(String command) {
    setState(() { // we need this to update children; TODO really?
      runCtrl.run(command);
    });
  }

  void _saveFile() async {
    final filePath = await FilePicker.platform.saveFile(dialogTitle: "Save file", fileName: "test.json", allowedExtensions: ["json"], lockParentWindow: true);
    if (filePath != null) { // user may cancel
      // TODO: check on Windows "if file exists" (on MacOS norm)
      File(filePath).writeAsString(jsonEncode(_model.toJson()), flush: true);
    }
  }

  void _openFile() async {
    final result = await FilePicker.platform.pickFiles(dialogTitle: "Open file", type: FileType.custom, allowedExtensions: ["json"], withData: true, lockParentWindow: true);
    if (result != null) { // user may cancel
      final bytes = result.files.first.bytes!;
      final str = Utf8Decoder().convert(bytes);
      final json = jsonDecode(str);
      final model = TestModel.fromJson(json);
      setState(() {
        _model = model;
      });
    }
  }
}

class RunIntent extends Intent {}
