import 'package:flutter/material.dart';

class CampoForm extends StatelessWidget {
  const CampoForm({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.hintText,
    required this.validator,
  });

  final TextEditingController? controller;
  final bool obscureText;
  final String? hintText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromRGBO(248, 250, 255, 1),
        hintText: hintText,
        contentPadding: const EdgeInsets.fromLTRB(22, 8, 0, 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        constraints: const BoxConstraints(
          maxWidth: 296,
          maxHeight: 60,
        ),
      ),
      validator: validator,
    );
  }
}
