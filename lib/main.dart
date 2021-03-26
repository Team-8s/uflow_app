import 'package:flutter/material.dart';
import 'package:uflow_app/register_user_screen.dart';
import 'input_page.dart';
import 'login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() => runApp(InitApp());

class InitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Inistializing Firebase');
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot){
        if(snapshot.hasError){
          print(snapshot.error);
          // TODO: Create a screen from app crash on initialization
          return Text('Something went wrong', textDirection: TextDirection.ltr,);
        } else if(snapshot.connectionState == ConnectionState.done){
          return MyApp();
        } else {
          // TODO: Create a splash screen
          return Text('Loading', textDirection: TextDirection.ltr,);
        }
      },
    );
  }
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      // home: MyStatefulWidget(),
            initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register-user': (context) => RegisterUserScreen(),
        '/home': (context) => MyStatefulWidget(),
      },
    );
  }
}
