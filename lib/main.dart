// ignore_for_file: use_key_in_widget_constructors
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:menubar/menubar.dart';
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
  final runCtrl = FunctionController<TestModel>();
  final commandCtrl = TextEditingController();
  TestModel _model = TestModel();

  @override
  void initState() {
    super.initState();
    if (!Platform.isMacOS) _createNativeMenu(); // tmp solution to create menu on Windows/Linux
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<TestModel>(
      model: _model,
      child: PlatformMenuBar( // MacOS only
        menus: [
          PlatformMenu(label: "Hey-Hey", menus: [
            PlatformMenuItem(label: "Quit", shortcut: const SingleActivator(LogicalKeyboardKey.keyW, meta: true), onSelected: () => exit(0))
          ]),
          PlatformMenu(label: "File", menus: [
            PlatformMenuItem(label: "Open", shortcut: const SingleActivator(LogicalKeyboardKey.keyO, meta: true), onSelected: _openFile),
            PlatformMenuItem(label: "Save", shortcut: const SingleActivator(LogicalKeyboardKey.keyS, meta: true), onSelected: _saveFile)
          ]),
          PlatformMenu(label: "Build", menus: [
            PlatformMenuItem(label: "Run", shortcut: const SingleActivator(LogicalKeyboardKey.enter), onSelected: _run),
          ])
        ],
        child: Shortcuts(
          shortcuts: {
            // even though we have "Run" in main menu, we still need this shortcut, because otherwise in Text fields it will require to press ENTER twice
            const SingleActivator(LogicalKeyboardKey.enter): RunIntent(),
            const SingleActivator(LogicalKeyboardKey.keyD, meta: true): DebugIntent(),
          },
          // even though we have "_model" member available, we still have to use ScopedModelDescendant to update children widgets
          child: ScopedModelDescendant<TestModel>(builder: (context, _, model) {
            return Actions(
              actions: {
                RunIntent: CallbackAction(onInvoke: (_) => _run()),
                DebugIntent: CallbackAction(onInvoke: (_) => print(model.toJson())),
              },
              child: Focus(
                autofocus: true,
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 12, right: 12),
                    child: Row(children: [
                      Expanded(child: TextField(controller: commandCtrl, decoration: const InputDecoration(hintText: "Command"), onChanged: (s) => model.command = s)),
                      const Expanded(child: SizedBox()),
                      ElevatedButton(
                        onPressed: _run,
                          style: const ButtonStyle(minimumSize: MaterialStatePropertyAll(Size(120, 48))),
                          child: const Text("Run", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700))
                      )
                    ])
                  ),
                  Expanded(child: ListView.builder(
                    itemCount: model.scenariosCount + 1,
                    itemBuilder: (context, i) {
                      return i == model.scenariosCount
                        ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            TrixIconTextButton(icon: const Icon(Icons.add_circle_outline), label: "Scenario", onTap: () => model.addScenario())
                          ])
                        : ScenarioWidget(i, runCtrl);
                    }
                  ))
                ]),
              )
            );
          })
        )
      )
    );
  }

  void _run() {
    setState(() { // we need this to update children properly
      runCtrl.run(_model);
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
      final str = const Utf8Decoder().convert(bytes);
      final json = jsonDecode(str);
      final model = TestModel.fromJson(json);
      setState(() {
        _model = model;
        commandCtrl.text = model.command;
      });
    }
  }

  void _createNativeMenu() {
    // This is a temp solution, until Flutter adds "PlatformMenuBar" support for Windows/Linux.
    // After that "menubar" dependency may also be removed
    setApplicationMenu([
      NativeSubmenu(label: "File", children: [
        NativeMenuItem(label: "Open", shortcut: LogicalKeySet(LogicalKeyboardKey.keyO, LogicalKeyboardKey.control), onSelected: _openFile),
        NativeMenuItem(label: "Save", shortcut: LogicalKeySet(LogicalKeyboardKey.keyS, LogicalKeyboardKey.control), onSelected: _saveFile),
        const NativeMenuDivider(),
        NativeMenuItem(label: "Quit", shortcut: LogicalKeySet(LogicalKeyboardKey.keyW, LogicalKeyboardKey.control), onSelected: () => exit(0)),
      ]),
      NativeSubmenu(label: "Build", children: [
        NativeMenuItem(label: "Run", shortcut: LogicalKeySet(LogicalKeyboardKey.keyB, LogicalKeyboardKey.control), onSelected: _run),
      ]),
    ]);
  }
}

class RunIntent extends Intent {}
class DebugIntent extends Intent {}
