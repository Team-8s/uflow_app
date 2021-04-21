import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:provider/provider.dart';

import 'package:uflow_app/pages/play_page.dart';
import 'package:uflow_app/main.dart';


enum CalStep {
  notStarted,
  flexing,
  relaxing,
  done
}

class calibrationPage extends StatefulWidget {
  @override
  _calibrationPageState createState() => _calibrationPageState();
}

class _calibrationPageState extends State<calibrationPage> {

  

  CalStep calState = CalStep.notStarted;

  bool calibrationHasStarted = false;
  bool isFlexed = false;
  double time = 0;
  double countDown = 20;
  int floorValueEmg1 = 1000;
  int floorValueEmg2 = 1000;
  int ceilingValueEmg1 = 0;
  int ceilingValueEmg2 = 0;
  @override
  Widget build(BuildContext context) {
    var emgData = Provider.of<EMGData>(context);
    var calData = Provider.of<CalibrationData>(context);
    return Scaffold(
          body: Container(
        color: Colors.blue,
        width: double.infinity,
        child: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(),
                Container(
                  width: double.infinity,
                  height: 500,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${emgData.emg1}'),
                          Text('${emgData.emg2}'),
                          Text('${calData.ceilingValueEmg2}'),
                          Text('${calData.ceilingValueEmg1}'),
                        ],
                      ),
                      Text(
                        'Calibration',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Divider(
                        color: Colors.black,
                        height: 20,
                        thickness: 2,
                        indent: 10,
                        endIndent: 10,
                      ),
                      SizedBox(),
                      RaisedButton(
                          onPressed: () {
                            startCalibration(context);
                          },
                          child: Text(countDown.toString())),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 1000),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(isFlexed ? 32 : 4),
                          ),
                          color: isFlexed ? Colors.green : Colors.red,
                        ),
                        height: isFlexed ? 250 : 150,
                        width: isFlexed ? 250 : 150,
                        curve: Curves.bounceOut,
                        child: isFlexed
                            ? Center(
                          child: Text(
                            'Flex',
                            style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        )
                            : Center(
                          child: Text(
                            'Relax',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            },
                          child: Text('Done'),
                      ),],
                  ),
                  margin: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                SizedBox(),
              ]),
        ),
      ),
    );
  }

  Widget calStateWidget(CalStep calStep){
    switch (calStep){
      case CalStep.notStarted:
        return calibrationNotStarted();
        break;
      case CalStep.flexing:
        return calibrationFlexing();
        break;
      case CalStep.relaxing:
        return calibrationRelaxing();
        break;
      case CalStep.done:
        return calibrationDone();
        break;
      default:
        return Text('Error');
    }
  }

  Widget calibrationNotStarted(){
    return Container(
      child: Text('Not Started')
    );
  }

  Widget calibrationFlexing(){
    return Text('Flexing');
  }

  Widget calibrationRelaxing(){
    return Text('Relaxing');
  }

  Widget calibrationDone(){
    return Text('Calibration done');
  }

  void startCalibration(BuildContext context) {
    var calData = Provider.of<CalibrationData>(context, listen: false);
    var sensorData = Provider.of<EMGData>(context, listen: false);
    calibrationHasStarted = true;
    Timer.periodic(Duration(milliseconds: 50), (Timer timer) {
      time += 0.01;
      countDown -= 0.05;
      if (countDown > 10) {
        setState(() {
          isFlexed = false;

          calState = CalStep.relaxing;

          if (floorValueEmg1 < sensorData.emg1){
            floorValueEmg1 = sensorData.emg1;
          }
          if (floorValueEmg2 < sensorData.emg2){
            floorValueEmg2 = sensorData.emg2;
          }
        });
      }
      if (countDown < 10 && countDown > 0) {
        setState(() {
          isFlexed = true;

          calState = CalStep.flexing;

          if (ceilingValueEmg1 < sensorData.emg1){
            ceilingValueEmg1 = sensorData.emg1;
          }
          if (ceilingValueEmg2 < sensorData.emg2){
            ceilingValueEmg2 = sensorData.emg2;
          }
        });
      }
      if (countDown < 0) {
        calData.floorValueEmg1 = ceilingValueEmg1;
        calData.floorValueEmg2 = ceilingValueEmg2;
        calData.ceilingValueEmg1 = ceilingValueEmg1;
        calData.ceilingValueEmg2 = ceilingValueEmg2;
        calData.calibrated = true;
        setState(() {
          isFlexed = false;

          calState = CalStep.done;

          timer.cancel();
          countDown = 20;
        });
      }
    });
  }
}


