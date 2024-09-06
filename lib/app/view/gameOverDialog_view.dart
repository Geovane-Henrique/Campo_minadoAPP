import 'package:flutter/material.dart';

class gameOverDialog extends StatelessWidget {
  final VoidCallback resetMap;
  final int showTime;
  const gameOverDialog(
      {super.key, required this.resetMap, required this.showTime});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Game over"),
      content: Text("$showTime segundos"),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetMap();
            },
            child: Text("Tentar novamente"))
      ],
    );
  }
}
