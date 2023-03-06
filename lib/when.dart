import 'package:flutter/material.dart';
import 'package:tommyspec/common/roundbox.dart';

class WhenWidget extends StatelessWidget {
  final TextEditingController argsCtrl;

  const WhenWidget({super.key, required this.argsCtrl});

  @override
  Widget build(BuildContext context) {
    return TrixContainer(child: Row(mainAxisSize: MainAxisSize.min, children: [
      Text("When"),
      SizedBox(width: 200, child: TextField(controller: argsCtrl),),
    ]));
  }
}
