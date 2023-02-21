import 'package:flutter/material.dart';

class TrixExpandPanel extends StatefulWidget {
  final Widget headerWidget;
  final Widget child;

  const TrixExpandPanel({super.key, required this.headerWidget, required this.child});

  @override
  State<TrixExpandPanel> createState() => _TrixExpandPanelState();
}

class _TrixExpandPanelState extends State<TrixExpandPanel> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      children: [
        ExpansionPanel(
          headerBuilder: (context, isOpen) => widget.headerWidget,
          body: widget.child,
          isExpanded: isExpanded,
          canTapOnHeader: true,
          //backgroundColor: Colors.blueGrey
        )
      ],
      expansionCallback: (i, isOpen) {
        setState(() {
          isExpanded = !isOpen;
        });
      },
    );
  }
}
