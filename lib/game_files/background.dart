import 'package:flutter/material.dart';

class MyBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Image.asset(
          'assets/images/background.PNG',
        ),
      ),
    );
  }
}
