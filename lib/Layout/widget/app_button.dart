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
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(8),
        color: fondoColor,
        child: Text(
          textoBoton,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
