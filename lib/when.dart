import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tommyspec/common/roundbox.dart';
import 'package:tommyspec/model/model.dart';

class WhenWidget extends StatelessWidget {
  final int idx;
  final argsController = TextEditingController();

  WhenWidget(this.idx);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TestModel>(
      builder: (context, _, model) {
        updateTextFields(model);
        return TrixContainer(child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text("When"),
          SizedBox(width: 200, child: TextField(controller: argsController, onChanged: (s) => model.setArgs(idx, s),)),
        ]));
      }
    );
  }

  void updateTextFields(TestModel model) {
    if (argsController.text != model.getArgsAsString(idx)) {
      // it's possible when we load a new model with ⌘+O
      argsController.text = model.getArgsAsString(idx);
    }
  }
}
