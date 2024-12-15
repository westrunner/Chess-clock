import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton(
      {super.key,
      required this.pepeOnTap,
      required this.textoBoton,
      required this.fondoColor});
  final Function() pepeOnTap;
  final String textoBoton;
  final Color fondoColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pepeOnTap,
      child: Container(
        height: 500,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        color: fondoColor,
        child: Text(
          textoBoton,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
