import 'package:flutter/material.dart';

class DropdownButtonWidget<T> extends StatefulWidget {
  final List<T> items;
  final T selectedItem;
  final void Function(T?)? onChanged;

  DropdownButtonWidget({
    required this.items,
    required this.selectedItem,
    required this.onChanged,
  });

  @override
  _DropdownButtonWidgetState<T> createState() => _DropdownButtonWidgetState<T>();
}

// ...

class _DropdownButtonWidgetState<T> extends State<DropdownButtonWidget<T>> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      value: widget.selectedItem,
      items: widget.items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(item.toString()),
        );
      }).toList(),
      onChanged: widget.onChanged,
    );
  }
}