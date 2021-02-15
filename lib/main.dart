import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.white,
                ),
              ),
              Container(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                        Widget>[
                  Container(
                    height: 30,
                    child: FlatButton.icon(
                      color: Colors.white,
                      icon: Icon(Icons.home, size: 18, color: Colors.black38),
                      label: Text('',
                          style:
                              TextStyle(fontSize: 13, color: Colors.black54)),
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    height: 30,
                    child: FlatButton.icon(
                      color: Colors.white,
                      icon: Icon(Icons.graphic_eq_outlined,
                          size: 18, color: Colors.black38),
                      label: Text('',
                          style:
                              TextStyle(fontSize: 13, color: Colors.black54)),
                      onPressed: () {},
                    ),
                  ),
                  // Container(
                  //   height: 30,
                  //   child: FlatButton.icon(
                  //     color: Colors.blue,
                  //     icon: Icon(Icons.play_arrow,
                  //         size: 18, color: Colors.black38),
                  //     label: Text('',
                  //         style:
                  //             TextStyle(fontSize: 13, color: Colors.black54)),
                  //     onPressed: () {},
                  //   ),
                  // ),
                  Container(
                    height: 30,
                    child: FlatButton.icon(
                      color: Colors.white,
                      icon:
                          Icon(Icons.healing, size: 18, color: Colors.black38),
                      label: Text('',
                          style:
                              TextStyle(fontSize: 13, color: Colors.black54)),
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    height: 30,
                    child: FlatButton.icon(
                      color: Colors.white,
                      icon: Icon(Icons.book, size: 18, color: Colors.black38),
                      label: Text('',
                          style:
                              TextStyle(fontSize: 13, color: Colors.black54)),
                      onPressed: () {},
                    ),
                  ),
                ]),
              ),
            ]),
      ),
    ));
  }
}
