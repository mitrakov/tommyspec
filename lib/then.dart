import 'package:flutter/material.dart';
import 'package:split_view/split_view.dart';
import 'package:tommyspec/and.dart';
import 'package:tommyspec/common/expand.dart';
import 'package:tommyspec/common/icontextbutton.dart';

class ThenWidget extends StatefulWidget {
  final TextEditingController statusCtrl;
  final TextEditingController stdoutCtrl;
  final TextEditingController stderrCtrl;

  const ThenWidget({super.key, required this.statusCtrl, required this.stdoutCtrl, required this.stderrCtrl});

  @override
  State<ThenWidget> createState() => _ThenWidgetState();
}

class _ThenWidgetState extends State<ThenWidget> {
  final statusExpectedCtrl = TextEditingController();
  int andItemCount = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 430+50.0*(andItemCount), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      Row(mainAxisSize: MainAxisSize.min, children: [
        Text("Then"),
        Text("Status code"),
        Expanded(child: TextField(controller: widget.statusCtrl, readOnly: true,)),
        Text("should be"),
        Expanded(child: TextField(controller: statusExpectedCtrl,)),
        _isStatusOk()
          ? Icon(Icons.done_outline, color: Colors.green)
          : Icon(Icons.do_not_disturb_alt_rounded, color: Colors.red)
      ],),
      TrixExpandPanel(headerWidget: Text("Output"), child: Container(height: 200, color: Colors.grey, child: SplitView(viewMode: SplitViewMode.Horizontal, children: [
        TextField(controller: widget.stdoutCtrl, maxLines: 4096),
        TextField(controller: widget.stderrCtrl, maxLines: 4096),
      ]))),
      Expanded(child: ListView.builder(
        itemCount: andItemCount + 1,
        itemBuilder: (context, i) {
          return i == andItemCount
            ? TrixIconTextButton(icon: Icon(Icons.add_circle_outline_outlined), label: "And", onTap: _addAndItem)
            : AndWidget(stdoutCtrl: widget.stdoutCtrl, stderrCtrl: widget.stderrCtrl);
        }
      ))
    ]),);
  }

  bool _isStatusOk() {
    return widget.statusCtrl.text.isNotEmpty && widget.statusCtrl.text == statusExpectedCtrl.text.trim();
  }

  void _addAndItem() {
    setState(() {
      andItemCount++;
    });
  }
}
