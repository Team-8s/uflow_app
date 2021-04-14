import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import '../game_files/barriers.dart';
import '../game_files/bird.dart';
import '../game_files/chipmunk.dart';
import '../game_files/text_assets.dart';

class Game extends StatefulWidget {
  @override
  PlayPage createState() => PlayPage();
}

class PlayPage extends State<Game> {
  static double birdYaxis = 0;
  static double chipmunkYaxis = 1.10;
  static double birdScore = 0;
  static double chipmunkScore = 0;
  double time = 0;
  double birdPathI = 0;
  double countDown = 10;
  double birdHeight = 0;
  double chipmunkHeight = 0;
  double initalBirdHeight = birdYaxis;
  double initalChipmunkHeight = chipmunkYaxis;
  bool gameHasStarted = false;
  static double pathXone = 1;
  static double pathYone = -0.25;
  static double pathXtwo = 1;
  static double pathYtwo = 0.95;

  void jump() {
    setState(() {
      time = 0;
      initalBirdHeight = birdYaxis;
    });
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      time += 0.01;
      birdPathI +=0.05;
      pathYone = 0.5*sin(birdPathI)-0.5;
      countDown -= 0.05;
      birdHeight = -4.9 * time * time + 2.8 * time;
      chipmunkHeight = 0.1*sin(birdPathI);
      print("time number is: $time");
      setState(() {
        birdYaxis = initalBirdHeight - birdHeight;
        chipmunkYaxis = initalChipmunkHeight - chipmunkHeight;
      });

      setState(() {
        if (birdYaxis < pathYone + 0.10 && birdYaxis > pathYone - 0.10) {
          birdScore = birdScore + (time);
          // print("time number is: $time");
          // print("lastTime number is: $lastTime");
          // print("birdScore number is: $birdScore");
        } else {
          birdScore = birdScore;
        }
      });
      setState(() {
        if (chipmunkYaxis < pathYtwo + 0.10 &&
            chipmunkYaxis > pathYtwo - 0.10) {
          chipmunkScore = chipmunkScore + (time);
          // print("time number is: $time");
          // print("lastTime number is: $lastTime");
          // print("birdScore number is: $birdScore");
        } else {
          chipmunkScore = chipmunkScore;
        }
      });

      if (countDown < 0) {
        timer.cancel();
        _showGameOverScreen();
        // if (birdScore > birdHighScore)
        //   {birdHighScore = birdScore;}
      }
    });
  }

  void _showGameOverScreen() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('GAME OVER'),
            content: Text('Bird: ' +
                birdScore.toStringAsPrecision(2) +
                ' Chipmunk: ' +
                chipmunkScore.toStringAsPrecision(2)),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                onPressed: () {
                  setState(() {
                    gameHasStarted = false;
                    birdYaxis = 0;
                    chipmunkYaxis = 1.10;

                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  });
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    birdYaxis = 0;
    chipmunkYaxis = 1.10;
    birdScore = 0;
    chipmunkScore = 0;
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 0),
                    color: Colors.blue,
                  ),
                  AnimatedContainer(
                    alignment: Alignment(pathXone, pathYone),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: double.infinity,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(pathXtwo, pathYtwo),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: double.infinity,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(-0.5, birdYaxis),
                    duration: Duration(milliseconds: 0),
                    child: MyBird(),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(-0.5, chipmunkYaxis),
                    duration: Duration(milliseconds: 0),
                    child: MyChipmunk(),
                  ),
                  Container(
                    alignment: Alignment(0, -0.35),
                    child: gameHasStarted
                        ? Text(countDown.toStringAsPrecision(2), style:
                        TextStyle(fontSize: 30.0, color: Colors.white),)
                        : Text(
                      "T A P  T O  P L A Y",
                      style:
                      TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 15.0,
              color: Colors.green,
            ),
            Expanded(
              child: Container(
                height: 200.0,
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ScoreDisplay(
                      scoreType: 'BIRD SCORE',
                      score: birdScore,
                    ),
                    ScoreDisplay(
                      scoreType: 'CHIPMUNK SCORE',
                      score: chipmunkScore,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
