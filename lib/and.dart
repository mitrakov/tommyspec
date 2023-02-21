import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_path/json_path.dart';
import 'package:tommyspec/dropdown.dart';
import 'package:tommyspec/expand.dart';

class AndWidget extends StatefulWidget {
  final TextEditingController stdoutCtrl;
  final TextEditingController stderrCtrl;
  const AndWidget({super.key, required this.stdoutCtrl, required this.stderrCtrl});

  @override
  State<AndWidget> createState() => _AndWidgetState();
}

class _AndWidgetState extends State<AndWidget> {
  final actualCtrl = TextEditingController();
  final processCtrl = TextEditingController();
  final asCtrl = TextEditingController();
  final transformCtrl = TextEditingController();
  final opCtrl = TextEditingController();
  final expectedCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _process();
    return TrixExpandPanel(
      headerWidget: Text("AND"),
      child: SizedBox(
        height: 145,
        child: Row(children: [
          Expanded(child: TextFormField(controller: actualCtrl, maxLines: 1024)),
          Expanded(child: Column(children: [
            Row(children: [
              Expanded(child: TrixDropdown(hintText: "Process", options: const ["Stdout", "Stderr"], getLabel: (s) => s, onChanged: (s) => processCtrl.text = s)),
              Expanded(child: TrixDropdown(hintText: "As", options: const ["Json", "XML"], getLabel: (s) => s, onChanged: (s) => asCtrl.text = s))
            ]),
            TextFormField(controller: transformCtrl),
            Row(children: [
              const Text("Should be"),
              Expanded(child: TrixDropdown(hintText: "Op", options: const ["=", ">", "<", "≥", "≤"], getLabel: (s) => s, onChanged: (s) => opCtrl.text = s)),
              Expanded(child: TextFormField(controller: expectedCtrl)),
              _isOk() ? const Icon(Icons.done_outline, color: Colors.green) : const Icon(Icons.do_not_disturb, color: Colors.red),
            ])
          ]))
        ])
      )
    );
  }

  void _process() {
    try {
      final s = widget.stdoutCtrl.text;
      final jmes = JsonPath("\$.${transformCtrl.text}");
      final json = jsonDecode(s);
      final result = jmes.read(json).map((e) => e.value).first;
      actualCtrl.text = result.toString();
    } catch(e) {
      print(e);
    }
  }

  bool _isOk() {
    return actualCtrl.text == expectedCtrl.text;
  }
}
