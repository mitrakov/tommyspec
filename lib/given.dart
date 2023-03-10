import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tommyspec/common/roundbox.dart';
import 'package:tommyspec/common/textbox.dart';
import 'package:tommyspec/model/model.dart';

class GivenWidget extends StatelessWidget {
  final int idx;
  final pwdCtrl = TextEditingController();
  final envCtrl = TextEditingController();

  GivenWidget(this.idx);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TestModel>(
      builder: (context, _, model) {
        pwdCtrl.text = model.getPwd(idx) ?? "";
        envCtrl.text = model.getEnvAsString(idx);
        return TrixContainer(child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text("Given"),
          SizedBox(width: 200, child: TrixText(child: TextField(controller: pwdCtrl, decoration: InputDecoration(hintText: "Working directory")), onChanged: (s) => model.setWorkingDirectory(idx, s))),
          SizedBox(width: 200, child: TrixText(child: TextField(controller: envCtrl, decoration: InputDecoration(hintText: "Environment variables")), onChanged: (s) => model.setEnv(idx, s))),
        ]));
      }
    );
  }
}
