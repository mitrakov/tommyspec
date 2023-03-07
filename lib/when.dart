import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tommyspec/common/roundbox.dart';
import 'package:tommyspec/model/model.dart';

class WhenWidget extends StatelessWidget {
  final int idx;

  const WhenWidget(this.idx);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TestModel>(
      builder: (context, _, model) {
        return TrixContainer(child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text("When"),
          SizedBox(width: 200, child: TextFormField(initialValue: model.getArgsAsString(idx), onChanged: (s) => model.setArgs(idx, s),)),
        ]));
      }
    );
  }
}
