import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tommyspec/common/roundbox.dart';
import 'package:tommyspec/common/textbox.dart';
import 'package:tommyspec/model/model.dart';

class WhenWidget extends StatefulWidget {
  final int idx;

  WhenWidget(this.idx);

  @override
  State<WhenWidget> createState() => _WhenWidgetState();
}

class _WhenWidgetState extends State<WhenWidget> {
  final argsController = TextEditingController();
  final stdinController = TextEditingController();
  int _modelTs = 0;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TestModel>(
      builder: (context, _, model) {
        _updateTextFields(model);
        return TrixContainer(child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text("When"),
          SizedBox(width: 200, child: TrixText(child: TextField(controller: argsController), onChanged: (s) => model.setArgs(widget.idx, s))),
          SizedBox(width: 50),
          SizedBox(width: 400, child: TrixText(child: TextField(controller: stdinController), onChanged: (s) => model.setStdIn(widget.idx, s))),
        ]));
      }
    );
  }

  void _updateTextFields(TestModel model) {
    if (_modelTs != model.createdTs) {
      argsController.text = model.getArgsAsString(widget.idx);
      stdinController.text = model.getStdin(widget.idx);
      _modelTs = model.createdTs;
    }
  }
}
