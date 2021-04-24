import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final size;
  bool gameHasStarted;
  MyBarrier({this.size, gameHasStarted}) ;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 1000),
      width: size,
      height: 10.0,
      decoration: BoxDecoration(
          color: gameHasStarted ? Colors.red[300] : Colors.blue,
          // border: Border.all(width: 10, color: Colors.green[800]),
          // borderRadius: BorderRadius.circular(15)),
    ));
  }
}

