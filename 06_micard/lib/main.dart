import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.blueGrey,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('images/bulba.jpg'),
                ),
                Text('name',
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontFamily: 'Palette Mosaic')),
                Text('A SUBTITLE',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueGrey[100],
                        fontFamily: 'Source Sans Pro',
                        letterSpacing: 5,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 20,
                  width: 150,
                  child: Divider(
                    color: Colors.blueGrey.shade100
                  ),
                ),
                Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 55),
                  child: ListTile(
                    leading: Icon(Icons.attach_money, color: Colors.blueGrey),
                    title: Text(
                      'net worth not enough',
                      style: TextStyle(
                        fontFamily: 'Source Sans Pro',
                        color: Colors.blueGrey.shade800,
                        fontSize: 20
                      )
                    )
                  )
                ),
                Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 55),
                  child: ListTile(
                    leading: Icon(Icons.build, color: Colors.blueGrey),
                    title: Text(
                      'something goes here',
                      style: TextStyle(
                        fontFamily: 'Source Sans Pro',
                        color: Colors.blueGrey.shade800,
                        fontSize: 20
                      )
                    )
                  )
                ),
              ],
            ),
          )),
    );
  }
}
