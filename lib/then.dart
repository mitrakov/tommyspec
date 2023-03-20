// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:split_view/split_view.dart';
import 'package:tommyspec/and.dart';
import 'package:tommyspec/common/expand.dart';
import 'package:tommyspec/common/icontextbutton.dart';
import 'package:tommyspec/common/roundbox.dart';
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
        _updateTextFields(model);
        final andsCount = model.getAndsCount(i);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TrixContainer(
              child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text("Then", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                const Text("Status code:", style: TextStyle(fontWeight: FontWeight.w500)),
                SizedBox(width: 80, child: TextField(controller: widget.actualStatusCtrl, textAlign: TextAlign.center, readOnly: true)),
                const Text("should be:", style: TextStyle(fontWeight: FontWeight.w500)),
                SizedBox(width: 80, child: TextField(controller: expectedStatusCtrl, textAlign: TextAlign.center, onChanged: (s) => model.setExpectedStatus(i, s))),
                _isStatusOk(model)
                  ? const Icon(Icons.done_outline, color: Colors.green, size: 40)
                  : const Icon(Icons.do_not_disturb_alt_rounded, color: Colors.red, size: 40)
              ])
            ),
            TrixExpandPanel(
              headerWidget: const Padding(padding: EdgeInsets.only(top: 14), child: Text("Output", textAlign: TextAlign.center)),
              child: SizedBox(
                height: 200,
                child: SplitView(viewMode: SplitViewMode.Horizontal, gripSize: 5, children: [
                  TextField(controller: widget.stdoutCtrl, maxLines: 4096, readOnly: true, decoration: const InputDecoration(labelText: "Std Out")),
                  TextField(controller: widget.stderrCtrl, maxLines: 4096, readOnly: true, decoration: const InputDecoration(labelText: "Std Err"), style: TextStyle(color: Colors.red),)
                ])
              )
            ),
            SizedBox(height: 64*(andsCount + 1), child: ListView.builder(
              itemCount: andsCount + 1,
              itemBuilder: (context, j) {
                return j == andsCount
                  ? TrixIconTextButton(icon: const Icon(Icons.add_circle_outline_outlined), label: "And", onTap: () => _addAndItem(model))
                  : AndWidget(i, j, stdoutCtrl: widget.stdoutCtrl, stderrCtrl: widget.stderrCtrl);
              }
            ))
          ]
        );
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
