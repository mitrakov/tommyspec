// ignore_for_file: use_key_in_widget_constructors
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_path/json_path.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tommyspec/common/dropdown.dart';
import 'package:tommyspec/common/expand.dart';
import 'package:tommyspec/common/roundbox.dart';
import 'package:tommyspec/common/textbox.dart';
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

  final processCtrl = ValueNotifier(stdout);
  final asCtrl = ValueNotifier(csvText);
  final actualCtrl = TextEditingController();
  final queryCtrl = TextEditingController();
  final opCtrl = ValueNotifier(eq);
  final expectedCtrl = TextEditingController();
  int _modelTs = 0;

  @override
  Widget build(BuildContext context) {
    final i = widget.scenarioIdx;
    final j = widget.idx;
    return ScopedModelDescendant<TestModel>(
      builder: (context, _, model) {
        _updateTextFields(model);
        _process(model);
        return Stack(
          fit: StackFit.passthrough,
          children: [
            TrixContainer(
              child: TrixExpandPanel(
                headerWidget: const Padding(padding: EdgeInsets.only(top: 12, left: 2), child: Text("And", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700))),
                colour: const Color(0xFFFFFEFE),
                child: SizedBox(
                  height: 180,
                  child: Row(children: [
                    Expanded(child: TrixContainer(child: TextField(controller: actualCtrl, readOnly: true, maxLines: 1024))),
                    const SizedBox(width: 8),
                    Expanded(child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        Expanded(
                          child: TrixDropdown(hintText: "Process", controller: processCtrl, options: const [stdout, stderr], getLabel: (s) => s, onChanged: (s) => model.setStdOutOrErr(i, j, s==stdout))
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: TrixDropdown(hintText: "As", controller: asCtrl, options: const [csvText, json, xml, regex], getLabel: (s) => s, onChanged: (s) => model.setAs(i, j, s))
                        )
                      ]),
                      TrixText(child: TextField(controller: queryCtrl, decoration: const InputDecoration(labelText: "Query")), onChanged: (s) => model.setQuery(i, j, s)),
                      const SizedBox(height: 6),
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        const Text("should be", style: TextStyle(fontWeight: FontWeight.w500)),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 50,
                          child: TrixDropdown(hintText: "Op", controller: opCtrl, options: const [eq, gt, lt, ge, le], getLabel: (s) => s, onChanged: (s) => model.setOperation(i, j, s))
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TrixText(child: TextField(controller: expectedCtrl), onChanged: (s) => model.setExpectedValue(i, j, s))
                        ),
                        const SizedBox(width: 8),
                        _isOk(model)
                          ? const Icon(Icons.done_outline, color: Colors.green, size: 40)
                          : const Icon(Icons.do_not_disturb, color: Colors.red, size: 40),
                      ])
                    ]))
                  ])
                )
              )
            ),
            Align(alignment: Alignment.topRight, child: IconButton(icon: const Icon(Icons.close), onPressed: () => model.removeAnd(i, j)))
          ]
        );
      }
    );
  }

  void _updateTextFields(TestModel model) {
    if (_modelTs != model.createdTs) {
      final i = widget.scenarioIdx;
      final j = widget.idx;
      processCtrl.value = model.getStdOutOrErr(i, j) ? stdout : stderr;
      asCtrl.value = model.getAs(i, j);
      queryCtrl.text = model.getQuery(i, j);
      opCtrl.value = model.getOperation(i, j);
      expectedCtrl.text = model.getExpectedValue(i, j);
      _modelTs = model.createdTs;
    }
  }

  void _process(TestModel model) {
    final i = widget.scenarioIdx;
    final j = widget.idx;
    final s = model.getStdOutOrErr(i, j) ? widget.stdoutCtrl.text.trim() : widget.stderrCtrl.text.trim();
    final query = model.getQuery(i, j);
    if (s.isEmpty || query.isEmpty) return;

    try {
      switch (model.getAs(i, j)) {
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
    } catch (e) {
      actualCtrl.text = e.toString();
    }
  }

  bool _isOk(TestModel model) {
    final i = widget.scenarioIdx;
    final j = widget.idx;
    final actual = actualCtrl.text.trim();
    final expected = model.getExpectedValue(i, j);
    if (expected.isEmpty) return false;

    switch (model.getOperation(i, j)) {
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
