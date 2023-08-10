import 'package:flutter/material.dart';

class Hiperlink extends StatelessWidget {
  const Hiperlink({
    super.key,
    required this.texto,
    required this.caminho,
    required this.entrarCadastrar,
  });

  final String texto;
  final String caminho;
  final String entrarCadastrar;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          texto,
          style: const TextStyle(
            color: Color.fromRGBO(248, 250, 255, 1),
            fontSize: 16,
            fontFamily: 'Roboto',
          ),
        ),
        // Hyperlink Cadastre-se
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, caminho);
          },
          child: Text(
            entrarCadastrar,
            style: const TextStyle(
              color: Color.fromRGBO(248, 250, 255, 1),
              fontSize: 16,
              fontFamily: 'Roboto',
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
