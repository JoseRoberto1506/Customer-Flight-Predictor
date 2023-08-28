import 'package:flutter/material.dart';

class CheckboxListWidget<T> extends StatefulWidget {
  final List<T> items;
  final List<T> selectedItems;
  final void Function(List<T>)? onChanged;

  const CheckboxListWidget({
    required this.items,
    required this.selectedItems,
    required this.onChanged,
  });

  _CheckboxListWidgetState<T> createState() => _CheckboxListWidgetState<T>();
}

class _CheckboxListWidgetState<T> extends State<CheckboxListWidget<T>> {
  Map<T, bool> isCheckedMap = {};

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: widget.items.map((item) {
          return CheckboxListTile(
            title: Text(item.toString()),
            value: isCheckedMap[item] ?? false,
            onChanged: (bool? newValue) {
              setState(() {
                isCheckedMap[item] = newValue ?? false;
                widget.onChanged?.call(
                  widget.items
                      .where((item) => isCheckedMap[item] ?? false)
                      .toList(),
                );
              });
            },
            activeColor: Colors.blueAccent,
            checkColor: Colors.white,
            controlAffinity: ListTileControlAffinity.leading,
            tristate: true,
          );
        }).toList(),
      ),
    );
  }
}
