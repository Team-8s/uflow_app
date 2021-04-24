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
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20.0),
            Text(
              '  Instructions for Use',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Image.asset(
            'assets/images/Instructions.PNG',
            fit: BoxFit.fitWidth,
      ),
          ],
        ),
      ]
    );
  }
}
