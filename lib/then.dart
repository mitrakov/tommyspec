// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:split_view/split_view.dart';
import 'package:tommyspec/and.dart';
import 'package:tommyspec/common/expand.dart';
import 'package:tommyspec/common/icontextbutton.dart';
import 'package:tommyspec/model/model.dart';

class ThenWidget extends StatefulWidget {
  final int idx;
  final TextEditingController stdoutCtrl;
  final TextEditingController stderrCtrl;
  final TextEditingController actualStatusCtrl;

  const ThenWidget(this.idx, {required this.actualStatusCtrl, required this.stdoutCtrl, required this.stderrCtrl});

  @override
  State<ThenWidget> createState() => _ThenWidgetState();
}

class _ThenWidgetState extends State<ThenWidget> {
  final TextEditingController expectedStatusCtrl = TextEditingController();
  int _modelTs = 0;

  @override
  Widget build(BuildContext context) {
    final i = widget.idx;
    return ScopedModelDescendant<TestModel>(
      builder: (context, _, model) {
        final andsCount = model.getAndsCount(i);
        _updateTextFields(model);
        return SizedBox(height: 430+50.0*andsCount, child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisSize: MainAxisSize.min, children: [
            const Text("Then"),
            const Text("Status code"),
            Expanded(child: TextField(controller: widget.actualStatusCtrl, readOnly: true,)),
            const Text("should be"),
            Expanded(child: TextField(controller: expectedStatusCtrl, onChanged: (s) {
              return model.setExpectedStatus(i, s);
            },)),
            _isStatusOk(model)
              ? const Icon(Icons.done_outline, color: Colors.green)
              : const Icon(Icons.do_not_disturb_alt_rounded, color: Colors.red)
          ],),
          TrixExpandPanel(headerWidget: const Text("Output"), child: Container(height: 200, color: Colors.grey, child: SplitView(viewMode: SplitViewMode.Horizontal, children: [
            TextField(controller: widget.stdoutCtrl, maxLines: 4096),
            TextField(controller: widget.stderrCtrl, maxLines: 4096),
          ]))),
          Expanded(child: ListView.builder(
            itemCount: andsCount + 1,
            itemBuilder: (context, j) {
              return j == andsCount
                ? TrixIconTextButton(icon: const Icon(Icons.add_circle_outline_outlined), label: "And", onTap: () => _addAndItem(model))
                : AndWidget(i, j, stdoutCtrl: widget.stdoutCtrl, stderrCtrl: widget.stderrCtrl);
            }
          ))
        ]));
      }
    );
  }

  void _updateTextFields(TestModel model) {
    if (_modelTs != model.createdTs) {
      expectedStatusCtrl.text = model.getExpectedStatus(widget.idx);
      _modelTs = model.createdTs;
    }
  }

  bool _isStatusOk(TestModel model) {
    return widget.actualStatusCtrl.text.isNotEmpty && widget.actualStatusCtrl.text == model.getExpectedStatus(widget.idx);
  }

  void _addAndItem(TestModel model) {
    model.addAndCondition(widget.idx);
  }
}
