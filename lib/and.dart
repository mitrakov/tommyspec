import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_path/json_path.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tommyspec/common/dropdown.dart';
import 'package:tommyspec/common/expand.dart';
import 'package:tommyspec/model/model.dart';
import 'package:tommyspec/utils/txt_processor.dart';
import 'package:xpath_parse/xpath_selector.dart'; // update to null-safety version

class AndWidget extends StatefulWidget {
  final int scenarioIdx;
  final int idx;
  final TextEditingController stdoutCtrl;
  final TextEditingController stderrCtrl;
  const AndWidget(this.scenarioIdx, this.idx, {required this.stdoutCtrl, required this.stderrCtrl});

  @override
  State<AndWidget> createState() => _AndWidgetState();
}

class _AndWidgetState extends State<AndWidget> {
  static const stdout = "Stdout";
  static const stderr = "Stderr";
  static const csvText = "CSV/Text";
  static const json = "Json";
  static const xml = "XML";
  static const regex = "Regex";
  static const eq = "=";
  static const gt = ">";
  static const lt = "<";
  static const ge = "≥";
  static const le = "≤";

  final actualCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TestModel>(
      builder: (context, _, model) {
        _process(model);
        return TrixExpandPanel(
          headerWidget: Text("AND"),
          child: SizedBox(
            height: 145,
            child: Row(children: [
              Expanded(child: TextField(controller: actualCtrl, maxLines: 1024)),
              Expanded(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Expanded(child: TrixDropdown(hintText: "Process", options: const [stdout, stderr], getLabel: (s) => s, onChanged: (s) => model.setStdOutOrErr(widget.scenarioIdx, widget.idx, s==stdout))),
                  Expanded(child: TrixDropdown(hintText: "As", options: const [csvText, json, xml, regex], getLabel: (s) => s, onChanged: (s) => model.setAs(widget.scenarioIdx, widget.idx, s)))
                ]),
                TextFormField(initialValue: model.getQuery(widget.scenarioIdx, widget.idx), onChanged: (s) => model.setQuery(widget.scenarioIdx, widget.idx, s)),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  const Text("Should be"),
                  Expanded(child: TrixDropdown(hintText: "Op", options: const [eq, gt, lt, ge, le], getLabel: (s) => s, onChanged: (s) => model.setOperation(widget.scenarioIdx, widget.idx, s))),
                  Expanded(child: TextFormField(initialValue: model.getExpectedValue(widget.scenarioIdx, widget.idx), onChanged: (s) => model.setExpectedValue(widget.scenarioIdx, widget.idx, s))),
                  _isOk(model) ? const Icon(Icons.done_outline, color: Colors.green) : const Icon(Icons.do_not_disturb, color: Colors.red),
                ])
              ]))
            ])
          )
        );
      }
    );
  }

  void _process(TestModel model) {
    final s = model.getStdOutOrErr(widget.scenarioIdx, widget.idx) ? widget.stdoutCtrl.text.trim() : widget.stderrCtrl.text.trim();
    final query = model.getQuery(widget.scenarioIdx, widget.idx);
    if (s.isEmpty || query.isEmpty) return;
    try {
      switch (model.getAs(widget.scenarioIdx, widget.idx)) {
        case csvText:
          actualCtrl.text = TextProcessor.process(query, s);
          break;
        case json:
          actualCtrl.text = JsonPath("\$.$query").read(jsonDecode(s)).map((e) => e.value).first.toString();
          break;
        case xml:
          actualCtrl.text = XPath.source(s).query(query).list().first;
          break;
        case regex:
          actualCtrl.text = RegExp(query).firstMatch(s)?.group(0) ?? "";
          break;
      }
    } catch(e) {
      actualCtrl.text = e.toString();
    }
  }

  bool _isOk(TestModel model) {
    final actual = actualCtrl.text.trim();
    final expected = model.getExpectedValue(widget.scenarioIdx, widget.idx);
    if (expected.isEmpty) return false;
    switch (model.getOp(widget.scenarioIdx, widget.idx)) {
      case eq: return actual == expected;
      case gt:
        final x = double.tryParse(actual);
        final y = double.tryParse(expected);
        if (x == null || y == null) return false;
        return x > y;
      case lt:
        final x = double.tryParse(actual);
        final y = double.tryParse(expected);
        if (x == null || y == null) return false;
        return x < y;
      case ge:
        final x = double.tryParse(actual);
        final y = double.tryParse(expected);
        if (x == null || y == null) return false;
        return x >= y;
      case le:
        final x = double.tryParse(actual);
        final y = double.tryParse(expected);
        if (x == null || y == null) return false;
        return x <= y;
    }
    return false;
  }
}
