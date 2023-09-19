import 'package:flutter/material.dart';

class CaixaBonita extends StatelessWidget {
  const CaixaBonita({
    super.key,
    required this.filho,
  });

  final dynamic filho;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: 350,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 71, 70, 70),
          borderRadius: BorderRadius.circular(25),
          shape: BoxShape.rectangle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [filho],
          ),
        ),
      ),
    );
  }
}
