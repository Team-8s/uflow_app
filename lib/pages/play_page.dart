import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uflow_app/game_files/game_page.dart';
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
    var calData = Provider.of<CalibrationData>(context);
    return Container(
      color: Colors.white,
      child: Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(),
              Container(
                margin: EdgeInsets.fromLTRB(52.0, 30.0, 52.0, 20.0),
                child: Card(
                  color: (_collectingTask != null && _collectingTask.inProgress)
                      ? Colors.green[400]
                      : Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                        width: 4.0,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    height: 100.0,
                    width: 120.0,
                    child: TextButton(
                      child: ((_collectingTask != null &&
                              _collectingTask.inProgress)
                          ? const Text(
                              'Disconnect Device',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 22.0,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : const Text(
                              'Connect Device',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 22.0,
                              ),
                              textAlign: TextAlign.center,
                            )),
                      onPressed: () async {
                        if (_collectingTask != null &&
                            _collectingTask.inProgress) {
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
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(52.0, 30.0, 52.0, 20.0),
                child: Card(
                  color: (_collectingTask != null && _collectingTask.inProgress)
                      ? Colors.green[400]
                      : Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                        width: 4.0,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    height: 100.0,
                    width: 120.0,
                    child: TextButton(
                      child: const Text(
                        'Calibrate',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 22.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: (_collectingTask != null)
                          ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return calibrationPage();
                                  },
                                ),
                              );
                            }
                          : null,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(52.0, 30.0, 52.0, 20.0),
                child: Card(
                  color: (_collectingTask != null && _collectingTask.inProgress)
                      ? Colors.green[400]
                      : Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                        width: 4.0,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: TextButton(
                      onPressed: calData.calibrated
                          ? () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Game()));
                            }
                          : null,
                      // onPressed:  (){Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) => Game()));},
                      child: Container(
                        height: 100.0,
                        width: 240.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Play Game',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Icon(
                              Icons.play_arrow,
                              size: 55.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}




