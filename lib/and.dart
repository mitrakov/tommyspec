import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_path/json_path.dart';
import 'package:tommyspec/common/dropdown.dart';
import 'package:tommyspec/common/expand.dart';
import 'package:tommyspec/utils/txt_processor.dart';
import 'package:xpath_parse/xpath_selector.dart'; // update to null-safety version

class AndWidget extends StatefulWidget {
  final TextEditingController stdoutCtrl;
  final TextEditingController stderrCtrl;
  const AndWidget({super.key, required this.stdoutCtrl, required this.stderrCtrl});

  @override
  State<AndWidget> createState() => _AndWidgetState();
}

class _AndWidgetState extends State<AndWidget> {
  static const stdout = "Stdout";
  static const stderr = "Stderr";
  static const eq = "=";
  static const gt = ">";
  static const lt = "<";
  static const ge = "≥";
  static const le = "≤";

  final actualCtrl = TextEditingController();
  final asCtrl = TextEditingController();
  final transformCtrl = TextEditingController();
  final expectedCtrl = TextEditingController();

  bool stdoutOrErr = true;
  String op = eq;

  @override
  Widget build(BuildContext context) {
    _processText();
    return TrixExpandPanel(
      headerWidget: Text("AND"),
      child: SizedBox(
        height: 145,
        child: Row(children: [
          Expanded(child: TextField(controller: actualCtrl, maxLines: 1024)),
          Expanded(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Row(mainAxisSize: MainAxisSize.min, children: [
              Expanded(child: TrixDropdown(hintText: "Process", options: const [stdout, stderr], getLabel: (s) => s, onChanged: (s) => stdoutOrErr = s==stdout)),
              Expanded(child: TrixDropdown(hintText: "As", options: const ["Json", "XML"], getLabel: (s) => s, onChanged: (s) => asCtrl.text = s))
            ]),
            TextField(controller: transformCtrl),
            Row(mainAxisSize: MainAxisSize.min, children: [
              const Text("Should be"),
              Expanded(child: TrixDropdown(hintText: "Op", options: const [eq, gt, lt, ge, le], getLabel: (s) => s, onChanged: (s) => op = s)),
              Expanded(child: TextField(controller: expectedCtrl)),
              _isOk() ? const Icon(Icons.done_outline, color: Colors.green) : const Icon(Icons.do_not_disturb, color: Colors.red),
            ])
          ]))
        ])
      )
    );
  }

  void _processJson() {
    try {
      final s = stdoutOrErr ? widget.stdoutCtrl.text.trim() : widget.stderrCtrl.text.trim();
      final jmes = JsonPath("\$.${transformCtrl.text.trim()}");
      final result = jmes.read(jsonDecode(s)).map((e) => e.value).first;
      actualCtrl.text = result.toString();
    } catch(e) {
      actualCtrl.text = e.toString();
    }
  }

  void _processXml() {
    try {
      final s = stdoutOrErr ? widget.stdoutCtrl.text.trim() : widget.stderrCtrl.text.trim();
      final node = XPath.source(s).query(transformCtrl.text.trim());
      final result = node.list().first;
      actualCtrl.text = result.toString();
    } catch(e) {
      actualCtrl.text = e.toString();
    }
  }

  void _processText() {
    try {
      final s = stdoutOrErr ? widget.stdoutCtrl.text.trim() : widget.stderrCtrl.text.trim();
      final cmd = transformCtrl.text.trim();
      final result = TextProcessor.process(cmd, s);
      actualCtrl.text = result;
    } catch(e) {
      actualCtrl.text = e.toString();
    }
  }

  bool _isOk() {
    final actual = actualCtrl.text.trim();
    final expected = expectedCtrl.text.trim();
    if (expected.isEmpty) return false;
    switch (op) {
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
