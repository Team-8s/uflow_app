import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final size;

  MyBarrier({this.size}) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: 10.0,
      decoration: BoxDecoration(
          color: Colors.red[300],
          // border: Border.all(width: 10, color: Colors.green[800]),
          // borderRadius: BorderRadius.circular(15)),
    ));
  }
}

