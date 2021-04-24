import 'package:flutter/material.dart';

class settingsPage extends StatefulWidget {
  @override
  _settingsPageState createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {
  double volume = 0;
  double _currentSliderValue = 20;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(),
              Container(
                margin: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 3.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0)
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(10.0),
                  elevation: 5.0,
                  child: Container(
                    width: double.infinity,
                    height: 350,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Settings',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                        Divider(
                          color: Colors.blue,
                          height: 20,
                          thickness: 2,
                          indent: 10,
                          endIndent: 10,
                        ),
                        SizedBox(),
                        ElevatedButton(
                            onPressed: () {}, child: Text('Change Username')),
                        ElevatedButton(
                            onPressed: () {}, child: Text('Change Password')),
                        ElevatedButton(
                            onPressed: () {}, child: Text('Reset Data')),
                        Container(
                          child: Column(
                            children: [
                              Text(
                                'Volume',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  color: Colors.blue,
                                ),
                              ),
                              Slider(
                                value: _currentSliderValue,
                                min: 0,
                                max: 100,
                                divisions: 5,
                                label: _currentSliderValue.round().toString(),
                                onChanged: (double value) {
                                  setState(() {
                                    _currentSliderValue = value;
                                  });
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    // margin: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(),
            ]),
      ),
    );
  }
}
