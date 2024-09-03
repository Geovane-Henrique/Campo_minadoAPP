import 'package:flutter/material.dart';

class gameOverDialog extends StatelessWidget {
  final VoidCallback resetMap;
  const gameOverDialog({super.key, required this.resetMap});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Game over"),
      content: Text("bomba"),
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
