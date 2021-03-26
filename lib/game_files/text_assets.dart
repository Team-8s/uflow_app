import 'package:flutter/material.dart';

class ScoreDisplay extends StatelessWidget {
  ScoreDisplay({@required this.scoreType, this.score});

  final String scoreType;
  final double score;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          scoreType,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          score.toStringAsPrecision(2),
          style: TextStyle(color: Colors.white, fontSize: 35),
        )
      ],
    );


  }
}