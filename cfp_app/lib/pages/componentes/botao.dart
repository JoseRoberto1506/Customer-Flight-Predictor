import 'package:flutter/material.dart';

class Botao extends StatelessWidget {
  const Botao({
    super.key,
    required this.fn,
    required this.texto,
  });

  final Function()? fn;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF0EA5B0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: const Size(296, 40),
      ),
      onPressed: fn,
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 19.2,
          fontFamily: 'Roboto',
          color: Color.fromRGBO(248, 250, 255, 1),
        ),
      ),
    );
  }
}
