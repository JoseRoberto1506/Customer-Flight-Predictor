import 'package:flutter/material.dart';

class CampoForm extends StatelessWidget {
  const CampoForm({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.hintText,
    required this.validator,
    required this.icon,
  });

  final TextEditingController? controller;
  final bool obscureText;
  final String? hintText;
  final Icon icon;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF313133),
        prefixIcon: Align(
          widthFactor: 1.0, 
          heightFactor: 1.0, 
          child: icon, 
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.white, 
          fontSize: 18, 
        ),
        contentPadding: const EdgeInsets.fromLTRB(22, 8, 0, 8),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        constraints: const BoxConstraints(
          maxWidth: 296,
          maxHeight: 60,
        ),
      ),
      style: const TextStyle(
        color: Colors.white, 
        fontSize: 18, 
      ),
      validator: validator,
    );
  }
}
