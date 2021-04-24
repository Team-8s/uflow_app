import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import '../game_files/barriers.dart';
import '../game_files/bird.dart';
import '../game_files/chipmunk.dart';
import '../game_files/text_assets.dart';
import 'package:flutter_sinusoidals/flutter_sinusoidals.dart';
import 'package:provider/provider.dart';
import 'package:uflow_app/main.dart';

import 'cloud.dart';
import 'tree.dart';

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
  double treeX = 0;
  double cloudX = 0;
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
    var currentData = Provider.of<EMGData>(context, listen: false);
    var currentDataCal = Provider.of<CalibrationData>(context, listen: false);
    var random = new Random();
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      time += 0.01;
      birdPathI += 0.05;

      countDown -= 0.05;
      // setState(() {
      print(
          "The Calibration data is ${currentDataCal.ceilingValueEmg1}, ${currentDataCal.floorValueEmg1}, ${currentDataCal.ceilingValueEmg2}, ${currentDataCal.floorValueEmg2},");
      print("The emg1 data is ${currentData.emg1}");
      print("The emg2 data is ${currentData.emg2}");
      //   birdHeight = 0 - (currentData.emg1 - currentDataCal.floorValueEmg1) /
      //       (currentDataCal.ceilingValueEmg1 - currentDataCal.floorValueEmg1);
      //   print("The bird height is $birdHeight");
      //   chipmunkHeight = 1 -
      //       2 * (currentData.emg1 - currentDataCal.floorValueEmg1) /
      //           (currentDataCal.ceilingValueEmg1 -
      //               currentDataCal.floorValueEmg1);
      //   print("The Chipmunk height is $chipmunkHeight");
      // });
      //print("time number is: $time");
      setState(() {
        pathYone = 0.5 * sin(1.27 * (birdPathI + 1.7)) - 0.5;
        if (treeX < -2) {
          treeX = 3;
        } else {
          treeX -= 0.05;
        }
        treeX -= 0.1;
        if (cloudX < -2) {
          cloudX = 3;
        } else {
          cloudX -= 0.005;
        }
        treeX -= 0.1;
        // birdYaxis = initalBirdHeight - birdHeight;
        // chipmunkYaxis = initalChipmunkHeight - chipmunkHeight;
        // birdYaxis = birdHeight;
        // chipmunkYaxis = chipmunkHeight;
        birdYaxis = pathYone + 0.0005 * random.nextInt(100);
        chipmunkYaxis = pathYtwo + 0.001 * random.nextInt(100);
      });

      setState(() {
        if (birdYaxis < pathYone + 0.25 && birdYaxis > pathYone - 0.25) {
          birdScore = birdScore + (time) / 2 * 0.99;
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
          chipmunkScore = chipmunkScore + (time) / 2 * 0.99;
          // print("time number is: $time");
          // print("lastTime number is: $lastTime");
          // print("birdScore number is: $birdScore");
        } else {
          chipmunkScore = chipmunkScore;
        }
      });

      if (countDown < 0) {
        countDown = 0;
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
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment(0, 1),
                        height: 500,
                        color: Colors.red[300],
                      ),
                      // Container(
                      //   alignment: Alignment(0, -2),
                      //   height: 50,
                      //   color: Colors.blue,
                      // ),
                      Container(
                        alignment: Alignment(0, -1.15),
                        child: Sinusoidal(
                          reverse: true,
                          model: const SinusoidalModel(
                              formular: WaveFormular.normal,
                              amplitude: 130.0,
                              waves: 1,
                              frequency: -.5,
                              translate: 3.14),
                          child: Container(
                            height: 300,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment(0, 1.5),
                        child: Sinusoidal(
                          model: const SinusoidalModel(
                            formular: WaveFormular.normal,
                            amplitude: 130.0,
                            waves: 1,
                            frequency: -.5,
                          ),
                          child: Container(
                            height: 500,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AnimatedContainer(
                    alignment: Alignment(treeX, 1.10),
                    duration: Duration(milliseconds: 0),
                    child: MyTree(),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(cloudX, -1.10),
                    duration: Duration(milliseconds: 0),
                    child: MyCloud(),
                  ),
                  // AnimatedContainer(
                  //   alignment: Alignment(pathXone, pathYone),
                  //   duration: Duration(milliseconds: 0),
                  //   child: MyBarrier(
                  //     size: double.infinity,
                  //   ),
                  // ),
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
                        ? Text(
                            countDown.toStringAsPrecision(2),
                            style:
                                TextStyle(fontSize: 30.0, color: Colors.white),
                          )
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
