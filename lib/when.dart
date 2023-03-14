// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tommyspec/common/roundbox.dart';
import 'package:tommyspec/common/textbox.dart';
import 'package:tommyspec/model/model.dart';

class WhenWidget extends StatefulWidget {
  final int idx;

  const WhenWidget(this.idx);

  @override
  State<WhenWidget> createState() => _WhenWidgetState();
}

class _WhenWidgetState extends State<WhenWidget> {
  final argsCtrl = TextEditingController();
  final stdinCtrl = TextEditingController();
  int _modelTs = 0;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TestModel>(
      builder: (context, _, model) {
        _updateTextFields(model);
        return TrixContainer(child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Text("When", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(width: 50),
          Expanded(child: TrixText(
            child: TextField(controller: argsCtrl, decoration: const InputDecoration(labelText: "Command Line Arguments")),
            onChanged: (s) => model.setArgs(widget.idx, s)
          )),
          const SizedBox(width: 50),
          Expanded(child: TrixText(
            child: TextField(controller: stdinCtrl, decoration: const InputDecoration(labelText: "Std In")),
            onChanged: (s) => model.setStdIn(widget.idx, s)
          )),
          const SizedBox(width: 50),
        ]));
      }
    );
  }

  void _updateTextFields(TestModel model) {
    if (_modelTs != model.createdTs) {
      argsCtrl.text = model.getArgsAsString(widget.idx);
      stdinCtrl.text = model.getStdin(widget.idx);
      _modelTs = model.createdTs;
    }
  }
}
