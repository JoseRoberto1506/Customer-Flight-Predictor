import 'package:flutter/material.dart';

class Dropdown extends StatelessWidget {
  final TextEditingController controller;
  final List<String> dropOpcoes;
  final String hint;
  final Icon icon;
  Dropdown({
    super.key,
    required this.controller,
    required this.dropOpcoes,
    required this.hint,
    required this.icon,
  });

  final dropValue = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: dropValue,
        builder: (BuildContext context, String value, _) {
          return SizedBox(
              width: 296,
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                hint: Text(hint,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    )),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF313133),
                  prefixIcon: Align(
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: icon,
                  ),
                ),
                icon:
                    const Icon(Icons.expand_more_outlined, color: Colors.white),
                value: controller.text.isEmpty ? null : controller.text,
                onChanged: (escolha) {
                  controller.text = escolha.toString();
                },
                items: dropOpcoes
                    .map((op) => DropdownMenuItem(
                          value: op,
                          child: Text(op),
                        ))
                    .toList(),
              ));
        });
  }
}
