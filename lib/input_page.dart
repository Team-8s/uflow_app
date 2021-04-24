import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uflow_app/pages/bluetooth_serial/MainPage.dart';
import 'package:uflow_app/pages/home_page.dart';
import 'package:uflow_app/pages/settings_page.dart';
import 'pages/play_page.dart';
import 'pages/bluetooth_connect.dart';
import 'pages/results_page.dart';
import 'pages/blutooth_serial.dart';

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 1;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      homePage(),
      gamePage(),
      ResultsPage(),
      settingsPage(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('ÜFlow', style: TextStyle(fontSize: 32.0)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(
          color: Colors.blue,
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.question),
            label: 'Help',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.play),
            label: 'Play',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.chartLine),
            label: 'Results',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.cog),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
