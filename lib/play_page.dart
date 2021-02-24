import 'package:flutter/material.dart';

class Game extends StatelessWidget {
  Game();
  int score = 0;
  void scoreCounter() {
    score++;
    print(score.toString());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: scoreCounter,
      child: Container(
        child: Text(score.toString()),
        margin: EdgeInsets.all(15.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }
}
