import 'package:flutter/material.dart';

class TrixText extends StatelessWidget {
  final TextField child;
  final ValueChanged<String> onChanged;

  TrixText({super.key, required this.child, required this.onChanged}) {
    assert(child.controller != null, "TextField must have a TextEditingController");
  }

  @override
  Widget build(BuildContext context) {
    return Focus(child: child, onFocusChange: (focusTaken) {
      if (!focusTaken) {
        onChanged(child.controller?.text ?? "");
      }
    });
  }
}
