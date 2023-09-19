import 'package:flutter/material.dart';

class DropdownEspecial extends StatelessWidget {
  final ValueNotifier<String> dropValue;
  final ValueNotifier<String> clienteSelecionado;
  final List<String> dropOpcoes;
  final String hint;
  final Icon icon;

  DropdownEspecial({
    Key? key,
    required this.dropValue,
    required this.clienteSelecionado,
    required this.dropOpcoes,
    required this.hint,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 296,
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        hint: Text(
          hint,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF313133),
          prefixIcon: Align(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: icon,
          ),
        ),
        icon: const Icon(Icons.expand_more_outlined, color: Colors.white),
        value: dropValue.value,
        onChanged: (escolha) {
          dropValue.value = escolha!;
          clienteSelecionado.value = escolha!; // Atualize o clienteSelecionado
        },
        items: [
          DropdownMenuItem(
            value: '', // Valor vazio
            child: Text(
              '', // Texto vazio ou qualquer texto que você deseja exibir
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ...dropOpcoes
              .map(
                (op) => DropdownMenuItem(
                  value: op,
                  child: Text(
                    op,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
              .toList(),
        ],
        dropdownColor: const Color(0xFF242425),
      ),
    );
  }
}
