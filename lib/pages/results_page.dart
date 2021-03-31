import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class ResultsPage extends StatefulWidget {
  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            margin: EdgeInsets.all(15.0),
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              elevation: 7.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.all(18.0),
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: 10.0,
                      lineBarsData: [
                        LineChartBarData(
                          colors: [Colors.purple],
                          spots: [
                            FlSpot(1, 6),
                            FlSpot(2, 5),
                            FlSpot(3, 6),
                            FlSpot(4, 4),
                            FlSpot(5, 7),
                            FlSpot(6, 8),
                            FlSpot(7, 9),
                          ],
                        ),
                      ],
                      axisTitleData: FlAxisTitleData(
                        leftTitle: AxisTitle(
                          showTitle: true,
                          titleText: 'Score',
                          reservedSize: 16.0,
                          textStyle: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black,
                          ),
                        ),
                        bottomTitle: AxisTitle(
                          showTitle: true,
                          titleText: 'Day',
                          reservedSize: 16.0,
                          textStyle: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black,
                          ),
                        ),
                      )),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(15.0),
            child: Material(
              elevation: 7.0,
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                padding: EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(children: [
                  Row(
                    children: [
                      Text('High Score: '),
                      Text('9'),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Total trials: '),
                      Text('7'),
                    ],
                  ),
                ],),
              ),
            ),
          )
        ],
      ),
    );
  }
}
