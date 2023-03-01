import 'package:flutter/material.dart';
import 'package:tommyspec/common/roundbox.dart';

class GivenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TrixContainer(child: Row(mainAxisSize: MainAxisSize.min, children: [
      Text("Given"),
      SizedBox(width: 200, child: TextField(),),
    ]));
  }
}
