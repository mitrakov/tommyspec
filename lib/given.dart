// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tommyspec/common/roundbox.dart';
import 'package:tommyspec/common/textbox.dart';
import 'package:tommyspec/model/model.dart';

class GivenWidget extends StatefulWidget {
  final int idx;

  const GivenWidget(this.idx);

  @override
  State<GivenWidget> createState() => _GivenWidgetState();
}

class _GivenWidgetState extends State<GivenWidget> {
  final pwdCtrl = TextEditingController();
  final envCtrl = TextEditingController();
  int _modelTs = 0;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TestModel>(
      builder: (context, _, model) {
        _updateTextFields(model);
        return TrixContainer(
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Text("Given", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            const SizedBox(width: 50),
            Expanded(child: TrixText(
              child: TextField(controller: pwdCtrl, decoration: const InputDecoration(labelText: "Working directory")),
              onChanged: (s) => model.setWorkingDirectory(widget.idx, s)
            )),
            const SizedBox(width: 50),
            Expanded(child: TrixText(
              child: TextField(controller: envCtrl, decoration: const InputDecoration(labelText: "Environment variables")),
              onChanged: (s) => model.setEnv(widget.idx, s)
            )),
            const SizedBox(width: 50),
          ])
        );
      }
    );
  }

  void _updateTextFields(TestModel model) {
    if (_modelTs != model.createdTs) {
      pwdCtrl.text = model.getPwd(widget.idx) ?? "";
      envCtrl.text = model.getEnvAsString(widget.idx);
      _modelTs = model.createdTs;
    }
  }
}
