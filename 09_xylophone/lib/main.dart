import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(XylophoneApp());
}

class XylophoneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              createButton(1),
              createButton(2),
              createButton(3),
              createButton(4),
              createButton(5),
              createButton(6),
              createButton(7),
            ],
          )
        )
      )
    );
  }

  void playSound(int soundNumber) {
    final player = AudioCache();
    player.play('note$soundNumber.wav');
  }

  Expanded createButton(int soundNumber) {
    var buttonColors = [Colors.red, Colors.orange, Colors.yellow, Colors.lightGreen, Colors.green, Colors.blue, Colors.purple];
    return Expanded(
      child: TextButton(
        child: Text(''),
        onPressed: () {
          playSound(soundNumber);
        },
        style: TextButton.styleFrom(
          backgroundColor: buttonColors[soundNumber - 1],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0)
          )
        )
      ),
    );
  }
}
