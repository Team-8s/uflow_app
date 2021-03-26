import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.0,
      width: 180.0,
      child: Image.asset(
        'assets/images/bird.png',
      ),
    );
  }
}
