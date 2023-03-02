import 'package:flutter/material.dart';

class TrixIconTextButton extends StatelessWidget {
  final Icon icon;
  final String label;
  final GestureTapCallback onTap;

  const TrixIconTextButton({super.key, required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          Text(label, style: const TextStyle(color: Color(0xFF0000CF), decoration: TextDecoration.underline)),
        ]
      )
    );
  }
}
