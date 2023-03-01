import 'package:flutter/material.dart';
import 'package:tommyspec/common/icontextbutton.dart';
import 'package:tommyspec/given.dart';
import 'package:tommyspec/then.dart';
import 'package:tommyspec/when.dart';

class ScenarioWidget extends StatefulWidget {
  final TextEditingController stdoutCtrl;
  final TextEditingController stderrCtrl;
  const ScenarioWidget({super.key, required this.stdoutCtrl, required this.stderrCtrl});

  @override
  State<ScenarioWidget> createState() => _ScenarioWidgetState();
}

class _ScenarioWidgetState extends State<ScenarioWidget> {
  bool showGiven = false;
  bool showWhen = false;
  bool showThen = false;

  @override
  Widget build(BuildContext context) {
    return Card(elevation: 5, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      showGiven ? GivenWidget() : TrixIconTextButton(icon: Icon(Icons.add_circle_outline_outlined), label: "Given", onTap: _onGivenPressed),
      showWhen ? WhenWidget() : TrixIconTextButton(icon: Icon(Icons.add_circle_outline_outlined), label: "When", onTap: _onWhenPressed),
      showThen ? ThenWidget(stdoutCtrl: widget.stdoutCtrl, stderrCtrl: widget.stderrCtrl) : TrixIconTextButton(icon: Icon(Icons.add_circle_outline_outlined), label: "Then", onTap: _onThenPressed),
    ],),)
    ;
  }

  void _onGivenPressed() {
    setState(() {
      showGiven = !showGiven;
    });
  }

  void _onWhenPressed() {
    setState(() {
      showWhen = !showWhen;
    });
  }

  void _onThenPressed() {
    setState(() {
      showThen = !showThen;
    });
  }
}
