import 'package:flutter/material.dart';
import 'package:split_view/split_view.dart';
import 'package:tommyspec/and.dart';
import 'package:tommyspec/expand.dart';

class WhenThenWidget extends StatefulWidget {
  final TextEditingController stdoutCtrl;
  final TextEditingController stderrCtrl;

  const WhenThenWidget({super.key, required this.stdoutCtrl, required this.stderrCtrl});

  @override
  State<WhenThenWidget> createState() => _WhenThenWidgetState();
}

class _WhenThenWidgetState extends State<WhenThenWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 400, child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      Row(mainAxisSize: MainAxisSize.min, children: [
        Text("When"),
        SizedBox(width: 200, child: TextField(),),
      ],),
      Row(mainAxisSize: MainAxisSize.min, children: [
        Text("Then"),
        Text("Status code"),
        Expanded(child: TextField()),
        Text("should be"),
        Expanded(child: TextField()),
        const Icon(Icons.done_outline, color: Colors.green)
      ],),
      TrixExpandPanel(headerWidget: Text("Output"), child: Container(height: 200, color: Colors.grey, child: SplitView(viewMode: SplitViewMode.Horizontal, children: [
        TextField(controller: widget.stdoutCtrl, maxLines: 4096),
        TextField(controller: widget.stderrCtrl, maxLines: 4096),
      ]))),
      Expanded(child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, i) {
            return AndWidget(stdoutCtrl: widget.stdoutCtrl, stderrCtrl: widget.stderrCtrl);
          }
      ))
    ]),);
  }
}
