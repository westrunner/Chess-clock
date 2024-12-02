import 'package:flutter/material.dart';

void showGameOverDialog(
    {required String message,
    required BuildContext context,
    required void Function()? onPressed}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Game Over'),
        content: Text(message),
        actions: <Widget>[
          TextButton(child: Text('OK'), onPressed: onPressed),
        ],
      );
    },
  );
}
