import 'package:flutter/material.dart';

class DadoDoCompromisso extends StatelessWidget {
  const DadoDoCompromisso({
    super.key,
    required this.titulo,
    required this.conteudo,
  });

  final String titulo;
  final String conteudo;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          child: Text(
            titulo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Flexible(
          child: Wrap(children: [
            Text(
              conteudo,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
