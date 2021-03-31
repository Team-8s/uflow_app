import 'package:flutter/material.dart';

class calibrationPage extends StatefulWidget {
  @override
  _calibrationPageState createState() => _calibrationPageState();
}

class _calibrationPageState extends State<calibrationPage> {
  double volume = 0;
  double _currentSliderValue = 20;
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
                height: 350,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    Text(
                      'Calibration',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Divider(
                      color: Colors.black,
                      height: 20,
                      thickness: 2,
                      indent: 10,
                      endIndent: 10,
                    ),
                    SizedBox(),
                    ElevatedButton(onPressed: null, child: Text('Relax')),
                    ElevatedButton(onPressed: null, child: Text('Flex')),

                    
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
}
