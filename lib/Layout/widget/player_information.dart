import 'package:flutter/material.dart';

class PlayerInformation extends StatelessWidget {
  const PlayerInformation(
      {super.key,
      required this.time,
      required this.isFirstPlayer,
      required this.isActive});
  final int time;
  final bool isFirstPlayer;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    int minutes = (time ~/ 60000); // Convert milliseconds to minutes
    int seconds =
        ((time % 60000) ~/ 1000); // Convert remaining milliseconds to seconds
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedOpacity(
          opacity: isActive ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            width: 200, // Ancho del círculo
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  isFirstPlayer ? Colors.white : Colors.black,
                  // if (player == "White") Colors.white,
                  // if (player == "Black") Colors.black,
                  Colors.lightGreen,
                ],
                center: Alignment.center,
                radius: 0.5, // Controla el tamaño del gradiente
              ),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isFirstPlayer ? "White" : "Black",
              style: TextStyle(
                fontSize: 24,
                color: isFirstPlayer ? Colors.black : Colors.white,
              ),
            ),
            Text(
              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 48,
                color: isFirstPlayer ? Colors.black : Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
