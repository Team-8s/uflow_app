import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  String now = DateFormat("yyyy-MM-dd").format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      width: double.infinity,
      child: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(now, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
                      ],
                    ),
                    width: 175,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                  ),),
                  SizedBox(),
                  Container(
                    width: 175,
                    height: 100, decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),),)
                ],),
              SizedBox(),
              Container(
                width: double.infinity,
                height: 300,
                child: Text(
                  'Hello, Person with a Peeing Disorder',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                margin: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              SizedBox(),
              Container(
                child: Text(
                  'Next Therapy Session: 09 Hours and 32 Minutes',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                width: double.infinity,
                height: 100,
                margin: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),

                ),),
            ]),
      ),
    );
  }
}
