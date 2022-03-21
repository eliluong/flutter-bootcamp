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
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // TextButton(
              //   child: Text(''),
              //   onPressed: () {
              //     final player = AudioCache();
              //     player.play('note1.wav');
              //   },
              //   style: TextButton.styleFrom(
              //     backgroundColor: Colors.red
              //   )
              // ),
              // TextButton(
              //   child: Text(''),
              //   onPressed: () {
              //     final player = AudioCache();
              //     player.play('note2.wav');
              //   },
              //   style: TextButton.styleFrom(
              //     backgroundColor: Colors.orange
              //   )
              // ),
              // TextButton(
              //   child: Text(''),
              //   onPressed: () {
              //     final player = AudioCache();
              //     player.play('note3.wav');
              //   },
              //   style: TextButton.styleFrom(
              //     backgroundColor: Colors.yellow
              //   )
              // ),
              // TextButton(
              //   child: Text(''),
              //   onPressed: () {
              //     final player = AudioCache();
              //     player.play('note4.wav');
              //   },
              //   style: TextButton.styleFrom(
              //     backgroundColor: Colors.lightGreen
              //   )
              // ),
              // TextButton(
              //   child: Text(''),
              //   onPressed: () {
              //     final player = AudioCache();
              //     player.play('note5.wav');
              //   },
              //   style: TextButton.styleFrom(
              //     backgroundColor: Colors.green
              //   )
              // ),
              // TextButton(
              //   child: Text(''),
              //   onPressed: () {
              //     final player = AudioCache();
              //     player.play('note6.wav');
              //   },
              //   style: TextButton.styleFrom(
              //     backgroundColor: Colors.blue
              //   )
              // ),
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

int add() => 5 + 2;

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