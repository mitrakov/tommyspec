import 'package:flutter/material.dart';
import 'package:split_view/split_view.dart';
import 'package:tommyspec/and.dart';
import 'package:tommyspec/common/expand.dart';

class ThenWidget extends StatelessWidget {
  final TextEditingController stdoutCtrl;
  final TextEditingController stderrCtrl;

  const ThenWidget({super.key, required this.stdoutCtrl, required this.stderrCtrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 400, child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      Row(mainAxisSize: MainAxisSize.min, children: [
        Text("Then"),
        Text("Status code"),
        Expanded(child: TextField()),
        Text("should be"),
        Expanded(child: TextField()),
        const Icon(Icons.done_outline, color: Colors.green)
      ],),
      TrixExpandPanel(headerWidget: Text("Output"), child: Container(height: 200, color: Colors.grey, child: SplitView(viewMode: SplitViewMode.Horizontal, children: [
        TextField(controller: stdoutCtrl, maxLines: 4096),
        TextField(controller: stderrCtrl, maxLines: 4096),
      ]))),
      Expanded(child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, i) {
            return AndWidget(stdoutCtrl: stdoutCtrl, stderrCtrl: stderrCtrl);
          }
      ))
    ]),);
  }
}
