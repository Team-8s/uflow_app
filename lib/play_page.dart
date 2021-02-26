import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  PlayPage createState() => PlayPage();
}

class PlayPage extends State<Game> {
  int score = 195;
  bool isHeld = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('GAME'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Current State',
                  style: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Text(
                  score.toString(),
                  style: TextStyle(
                    fontSize: 100.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                color: score <= 200 ? Colors.red : Colors.green,
                child: Text(
                  score <= 200 ? 'RELAXED' : 'FLEXED',
                  style: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  score++;
                });
              },
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  'TAP ME',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                padding: EdgeInsets.only(bottom: 20.0),
                width: double.infinity,
                color: Colors.teal,
                height: 80.0,
              ),
            )
          ],
        ));
  }
}
