import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('UFlow App', style: TextStyle(fontSize: 75,fontWeight: FontWeight.bold)),

            TextField(
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
            ),
            TextField(
              onChanged: (value) {
                setState() {
                  _password = value;
                }
              },
            ),
            SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                try {
                  // _auth.signInWithEmailAndPassword(
                  //     email: _email, password: _password);
                  Navigator.pushNamed(context, '/home');
                } catch (e) {
                  print(e);
                }
              },
              child: Text("Login"),
            ),
            SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register-user');
              },
              child: Text("Register Here"),
            ),
          ],
        ),
      ),
    );
  }
}
