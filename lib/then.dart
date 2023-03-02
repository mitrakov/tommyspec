import 'package:flutter/material.dart';
import 'package:split_view/split_view.dart';
import 'package:tommyspec/and.dart';
import 'package:tommyspec/common/expand.dart';
import 'package:tommyspec/common/icontextbutton.dart';

class ThenWidget extends StatefulWidget {
  final TextEditingController stdoutCtrl;
  final TextEditingController stderrCtrl;

  const ThenWidget({super.key, required this.stdoutCtrl, required this.stderrCtrl});

  @override
  State<ThenWidget> createState() => _ThenWidgetState();
}

class _ThenWidgetState extends State<ThenWidget> {
  int itemCount = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 330+50.0*(itemCount), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
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
        itemCount: itemCount + 1,
        itemBuilder: (context, i) {
          return i == itemCount
            ? TrixIconTextButton(icon: Icon(Icons.add_circle_outline_outlined), label: "And", onTap: _addAndItem)
            : AndWidget(stdoutCtrl: widget.stdoutCtrl, stderrCtrl: widget.stderrCtrl);
        }
      ))
    ]),);
  }

  void _addAndItem() {
    setState(() {
      itemCount++;
    });
  }
}
