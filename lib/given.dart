import 'package:flutter/material.dart';
import 'package:tommyspec/common/roundbox.dart';

class GivenWidget extends StatelessWidget {
  final TextEditingController workDirCtrl;
  final TextEditingController envCtrl;

  const GivenWidget({super.key, required this.workDirCtrl, required this.envCtrl});

  @override
  Widget build(BuildContext context) {
    return TrixContainer(child: Row(mainAxisSize: MainAxisSize.min, children: [
      Text("Given"),
      SizedBox(width: 200, child: TextField(controller: workDirCtrl, decoration: InputDecoration(hintText: "Working directory")),),
      SizedBox(width: 200, child: TextField(controller: envCtrl, decoration: InputDecoration(hintText: "Environment variables")),),
    ]));
  }
}
