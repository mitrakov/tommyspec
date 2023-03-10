import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TrixText extends StatelessWidget {
  final TextField child;
  final ValueChanged<String> onChanged;

  TrixText({super.key, required this.child, required this.onChanged}) {
    assert(child.controller != null, "TextField must have a TextEditingController");
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        if (event.logicalKey == LogicalKeyboardKey.enter) {
          onChanged(child.controller?.text ?? "");
        }
      },
      child: Focus(child: child, onFocusChange: (focusTaken) {
        if (!focusTaken) {
          onChanged(child.controller?.text ?? "");
        }
      })
    );
  }
}
