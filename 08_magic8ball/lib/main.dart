import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    home: BallPage()
  ));
}

class BallPage extends StatelessWidget {
  const BallPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade200,
      appBar: AppBar(
        title: Text('what you wanna know?'),
        backgroundColor: Colors.red.shade900,
      ),
      body: Ball(

      ),
    );
  }
}

class Ball extends StatefulWidget {
  const Ball({ Key? key }) : super(key: key);

  @override
  State<Ball> createState() => _BallState();
}

class _BallState extends State<Ball> {
  int theBall = 1;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        child: Image.asset('images/ball$theBall.png'),
        onPressed: () {
          setState(() {
            theBall = Random().nextInt(5) + 1;
          });
        },
      ),
    );
  }
}