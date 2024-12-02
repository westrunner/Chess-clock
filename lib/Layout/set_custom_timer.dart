import 'package:flutter/material.dart';

void setCustomTimer({
  required BuildContext context,
  required Function(String)? onChanged,
  required void Function(int minutes, int seconds) onPressed,
}) {
  int minutes = 0;
  int seconds = 0;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Set Timer'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Minutes'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  minutes = int.tryParse(value) ?? 0;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Seconds'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  seconds = int.tryParse(value) ?? 0;
                },
              ),
              TextField(
                decoration:
                    InputDecoration(labelText: 'Bonus Time per Move (Seconds)'),
                keyboardType: TextInputType.number,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
              child: Text('OK'), onPressed: () => onPressed(minutes, seconds)),
        ],
      );
    },
  );
}
