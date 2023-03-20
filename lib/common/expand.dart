import 'package:flutter/material.dart';

class TrixExpandPanel extends StatefulWidget {
  final Widget headerWidget;
  final Widget child;
  final Color? colour;

  const TrixExpandPanel({super.key, required this.headerWidget, required this.child, this.colour});

  @override
  State<TrixExpandPanel> createState() => _TrixExpandPanelState();
}

class _TrixExpandPanelState extends State<TrixExpandPanel> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: ExpansionPanelList(
        expandedHeaderPadding: EdgeInsets.zero,
        children: [
          ExpansionPanel(
            headerBuilder: (context, isOpen) => widget.headerWidget,
            body: widget.child,
            isExpanded: isExpanded,
            canTapOnHeader: true,
            backgroundColor: widget.colour ?? const Color(0xFFF0F0FE)
          )
        ],
        expansionCallback: (i, isOpen) {
          setState(() {
            isExpanded = !isOpen;
          });
        }
      )
    );
  }
}
