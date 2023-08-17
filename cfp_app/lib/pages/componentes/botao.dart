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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)),
        minimumSize: const Size(150, 50),
        maximumSize: const Size(296, 50),
      ),
      onPressed: fn,
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 19.5,
          fontFamily: 'Roboto',
          color: Colors.white,
        ),
      ),
    );
  }
}
