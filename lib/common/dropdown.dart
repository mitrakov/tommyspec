import 'package:flutter/material.dart';

class TrixDropdown<T> extends StatefulWidget {
  final String hintText;
  final List<T> options;
  final String Function(T) getLabel;
  final void Function(T) onChanged;
  final T? value;

  const TrixDropdown({
    super.key,
    required this.hintText,
    required this.options,
    required this.getLabel,
    required this.onChanged,
    this.value,
  });

  @override
  State<TrixDropdown<T>> createState() => _TrixDropdownState<T>();
}

class _TrixDropdownState<T> extends State<TrixDropdown<T>> {
  late T? value;

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      builder: (FormFieldState<T> state) {
        return InputDecorator(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            labelText: widget.hintText,
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          ),
          isEmpty: value == null || value == '',
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isDense: true,
              onChanged: (t) {
                widget.onChanged(t as T);
                setState(() {
                  value = t;
                });
              },
              items: widget.options.map((T value) {
                return DropdownMenuItem<T>(value: value, child: Text(widget.getLabel(value)));
              }).toList()
            )
          )
        );
      }
    );
  }
}
