import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tommyspec/common/roundbox.dart';
import 'package:tommyspec/model/model.dart';

class GivenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TommyModel>(
      builder: (context, _, model) {
        return TrixContainer(child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text("Given"),
          SizedBox(width: 200, child: TextFormField(initialValue: model.pwd, decoration: InputDecoration(hintText: "Working directory"), onChanged: (s) => model.setPwd(s))),
          SizedBox(width: 200, child: TextFormField(initialValue: model.envAsString, decoration: InputDecoration(hintText: "Environment variables"), onChanged: (s) => model.setEnv(s))),
        ]));
      }
    );
  }
}
