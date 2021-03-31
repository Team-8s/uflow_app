import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../game_files/barriers.dart';
import '../game_files/bird.dart';
import '../game_files/chipmunk.dart';
import '../game_files/text_assets.dart';

class gamePage extends StatefulWidget {
  @override
  _gamePageState createState() => _gamePageState();
}

class _gamePageState extends State<gamePage> {
  double birdHighScore = 0;
  double chipmunkHighScore = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      width: double.infinity,
      child: Container(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
                Widget>[
          SizedBox(),
          FlatButton(
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Game()));
              },
              child: Container(
                margin: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                height: 175,
                width: 175,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.play,
                      size: 50,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Play Now',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
              )),
          SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 150,
                width: 150,
                margin: EdgeInsets.all(15.0),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bird High Score',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                    Text(
                      birdHighScore.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Container(
                height: 150,
                width: 150,
                margin: EdgeInsets.all(15.0),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Chipmunk High Score',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                    Text(
                      chipmunkHighScore.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                    )
                  ],
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}

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
      countDown -= 0.05;
      birdHeight = -4.9 * time * time + 2.8 * time;
      chipmunkHeight = sin(0.5 * time);
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
                birdScore.toString() +
                ' Chipmunk: ' +
                chipmunkScore.toString()),
            actions: <Widget>[
              FlatButton(
                child: Text('Home'),
                onPressed: () {
                  setState(() {
                    gameHasStarted = false;
                    birdYaxis = 0;
                    chipmunkYaxis = 1.10;
                    Navigator.pushNamed(context, '/home');
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
                      size: 10.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(pathXtwo, pathYtwo),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: 10.0,
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
                        ? Text(countDown.toString())
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
