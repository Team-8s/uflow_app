import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class calibrationPage extends StatefulWidget {
  @override
  _calibrationPageState createState() => _calibrationPageState();
}

class _calibrationPageState extends State<calibrationPage> {
  bool calibrationHasStarted = false;
  bool isFlexed = false;
  double time = 0;
  double countDown = 10;
  @override
  Widget build(BuildContext context) {
    return Container(
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
                          startCalibration();
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
                    )
                  ],
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
    );
  }

  void startCalibration() {
    calibrationHasStarted = true;
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      time += 0.01;
      countDown -= 0.05;
      if (countDown > 5) {
        setState(() {
          isFlexed = false;
        });
      }
      if (countDown < 5 && countDown > 0) {
        setState(() {
          isFlexed = true;
        });
      }
      if (countDown < 0) {
        setState(() {
          isFlexed = false;
          timer.cancel();
          countDown = 10;
        });
      }
    });
  }
}
