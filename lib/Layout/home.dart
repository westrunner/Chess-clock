import 'dart:async';

import 'package:chess_clock/Layout/dialog/set_custom_timer.dart';
import 'package:chess_clock/Layout/dialog/show_game_over_dialog.dart';
import 'package:chess_clock/Layout/widget/app_button.dart';
import 'package:chess_clock/Layout/widget/player_information.dart';
import 'package:flutter/material.dart';

class ChessClock extends StatefulWidget {
  @override
  _ChessClockState createState() => _ChessClockState();
}

class _ChessClockState extends State<ChessClock> {
  static const int initialTime = 300; // 5 minutes in seconds
  int player1Time = initialTime * 1000; // Convert to milliseconds
  int player2Time = initialTime * 1000; // Convert to milliseconds
  Timer? timer;
  bool isPlayer1Turn = false;
  bool isPaused = false;
  int addTimePerMove = 0; // Time to add after each move (in seconds)

  void startTimer() {
    timer?.cancel(); // Cancel any existing timer
    timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (!isPaused) {
        setState(() {
          if (isPlayer1Turn) {
            if (player1Time > 0) {
              player1Time -= 100; // Decrease by 100 milliseconds
            } else {
              this.timer?.cancel();
              showGameOverDialog(
                message: 'Black player time is up!',
                context: context,
                onPressed: () {
                  Navigator.of(context).pop();
                  restart();
                },
              );
            }
          } else {
            if (player2Time > 0) {
              player2Time -= 100; // Decrease by 100 milliseconds
            } else {
              this.timer?.cancel();
              showGameOverDialog(
                message: 'White player time is up!',
                context: context,
                onPressed: () {
                  Navigator.of(context).pop();
                  restart();
                },
              );
            }
          }
        });
      }
    });
  }

  void switchTurn() {
    setState(() {
      isPlayer1Turn = !isPlayer1Turn;
      // Add bonus time only if the game has started
      if (isPlayer1Turn) {
        player2Time +=
            addTimePerMove * 1000; // Add time to player 1 (in milliseconds)
      } else {
        player1Time +=
            addTimePerMove * 1000; // Add time to player 2 (in milliseconds)
      }
    });
    startTimer();
  }

  void pause() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  void restart() {
    setState(() {
      player1Time = initialTime * 1000; // Reset to initial time in milliseconds
      player2Time = initialTime * 1000; // Reset to initial time in milliseconds
      addTimePerMove = 0;
      isPaused = false;
      isPlayer1Turn = false;
    });
    timer?.cancel(); // Stop the active timer
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Transform.rotate(
                angle: 3.14159, // Rotate 180 degrees
                child: PlayerInformation(
                  time: player2Time,
                  isFirstPlayer: true,
                  isActive: !isPlayer1Turn,
                  miOnTap: () {
                    if (!isPaused && !isPlayer1Turn) {
                      switchTurn();
                    }
                  },
                )),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AppButton(
                    pepeOnTap: pause,
                    textoBoton: isPaused ? 'Resume' : 'Pause',
                    fondoColor: Colors.pink.shade200,
                  ),
                  AppButton(
                    pepeOnTap: restart,
                    textoBoton: 'restart',
                    fondoColor: Colors.lightBlueAccent,
                  ),
                  AppButton(
                    pepeOnTap: () => setCustomTimer(
                      context: context,
                      onChanged: (value) {
                        addTimePerMove = int.tryParse(value) ?? 0;
                      },
                      onPressed: (minutes, seconds) {
                        setState(() {
                          player1Time = (minutes * 60 + seconds) *
                              1000; // Convert to milliseconds
                          player2Time = (minutes * 60 + seconds) *
                              1000; // Convert to milliseconds
                          isPaused = false;
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                    textoBoton: 'Set Timer',
                    fondoColor: Colors.lightGreen,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              flex: 3,
              child: PlayerInformation(
                time: player1Time,
                isFirstPlayer: false,
                isActive: isPlayer1Turn,
                miOnTap: () {
                  if (!isPaused && isPlayer1Turn) {
                    switchTurn();
                  }
                },
              )),
        ],
      ),
    );
  }
}
