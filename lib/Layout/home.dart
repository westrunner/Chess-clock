import 'dart:async';

import 'package:chess_clock/Layout/set_custom_timer.dart';
import 'package:chess_clock/Layout/show_game_over_dialog.dart';
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
            child: GestureDetector(
              onTap: () {
                if (!isPaused && !isPlayer1Turn) {
                  switchTurn();
                }
              },
              child: Transform.rotate(
                angle: 3.14159, // Rotate 180 degrees
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: buildTimer(player2Time, 'White',
                        !isPlayer1Turn), // Invert logic here
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: pause,
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text(isPaused ? 'Resume' : 'Pause'),
                  ),
                  ElevatedButton(
                    onPressed: () => setCustomTimer(
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
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text('Set Timer'),
                  ),
                  ElevatedButton(
                    onPressed: restart,
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text('Restart'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () {
                if (!isPaused && isPlayer1Turn) {
                  switchTurn();
                }
              },
              child: Container(
                color: Colors.black,
                child: Center(
                  child: buildTimer(player1Time, 'Black',
                      isPlayer1Turn), // Invert logic here as well
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTimer(int time, String player, bool isActive) {
    int minutes = (time ~/ 60000); // Convert milliseconds to minutes
    int seconds =
        ((time % 60000) ~/ 1000); // Convert remaining milliseconds to seconds

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          player,
          style: TextStyle(
            fontSize: 24,
            color: player == 'White' ? Colors.black : Colors.white,
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 48,
                  color: player == 'White' ? Colors.black : Colors.white,
                ),
              ),
              // Green line below the opposite timer
              if (isActive)
                Container(
                  margin: EdgeInsets.only(top: 8),
                  height: 3,
                  width: MediaQuery.of(context).size.width *
                      0.4, // Adjust to 40% of the screen width (you can change this value)
                  color: Colors.green, // Green line
                ),
            ],
          ),
        ),
      ],
    );
  }
}
