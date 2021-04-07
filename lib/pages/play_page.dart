import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../game_files/barriers.dart';
import '../game_files/bird.dart';
import '../game_files/chipmunk.dart';
import '../game_files/text_assets.dart';
import 'calibration_page.dart';
import 'package:provider/provider.dart';
import 'package:uflow_app/main.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'bluetooth_serial/MainPage.dart';
import 'package:scoped_model/scoped_model.dart';
import 'bluetooth_serial/BackgroundCollectedPage.dart';
import 'bluetooth_serial/BackgroundCollectingTask.dart';
import 'bluetooth_serial/DiscoveryPage.dart';
import 'bluetooth_serial/SelectBondedDevicePage.dart';

class gamePage extends StatefulWidget {
  @override
  _gamePageState createState() => _gamePageState();
}

class _gamePageState extends State<gamePage> {
  double birdHighScore = 0;
  double chipmunkHighScore = 0;

  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  String _address = "...";
  String _name = "...";

  Timer _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;

  BackgroundCollectingTask _collectingTask;

  bool _autoAcceptPairingRequests = false;

  Future<void> _startBackgroundTask(
    BuildContext context,
    BluetoothDevice server,
  ) async {
    try {
      _collectingTask = await BackgroundCollectingTask.connect(server, context);
      await _collectingTask.start();
    } catch (ex) {
      if (_collectingTask != null) {
        _collectingTask.cancel();
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error occured while connecting'),
            content: Text("${ex.toString()}"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if (await FlutterBluetoothSerial.instance.isEnabled) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address;
        });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name;
      });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        // Discoverable mode is disabled when Bluetooth gets disabled
        _discoverableTimeoutTimer = null;
        _discoverableTimeoutSecondsLeft = 0;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    _collectingTask?.dispose();
    _discoverableTimeoutTimer?.cancel();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    var currentData = Provider.of<EMGData>(context);
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
                      currentData.emg1.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
              )),
          SizedBox(),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => calibrationPage()));
            },
            child: Text('Calibration', style: TextStyle(color: Colors.black)),
          ),
          ListTile(
              title: RaisedButton(
                child: ((_collectingTask != null && _collectingTask.inProgress)
                    ? const Text('Disconnect and stop background collecting')
                    : const Text('Connect to start background collecting')),
                onPressed: () async {
                  if (_collectingTask != null && _collectingTask.inProgress) {
                    await _collectingTask.cancel();
                    setState(() {
                      /* Update for `_collectingTask.inProgress` */
                    });
                  } else {
                    final BluetoothDevice selectedDevice =
                        await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return SelectBondedDevicePage(
                              checkAvailability: false);
                        },
                      ),
                    );

                    if (selectedDevice != null) {
                      await _startBackgroundTask(context, selectedDevice);
                      setState(() {
                        /* Update for `_collectingTask.inProgress` */
                      });
                    }
                  }
                },
              ),
            ),
            ListTile(
              title: RaisedButton(
                child: const Text('View background collected data'),
                onPressed: (_collectingTask != null)
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return ScopedModel<BackgroundCollectingTask>(
                                model: _collectingTask,
                                child: BackgroundCollectedPage(),
                              );
                            },
                          ),
                        );
                      }
                    : null,
              ),
            ),
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
                      'Play Now',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                    )
                  ],
                ),
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
                child: Text('Done'),
                onPressed: () {
                  setState(() {
                    gameHasStarted = false;
                    birdYaxis = 0;
                    chipmunkYaxis = 1.10;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => gamePage()));
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
