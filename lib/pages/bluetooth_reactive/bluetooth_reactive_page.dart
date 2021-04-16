// import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
// import 'package:flutter/material.dart';

// class BluetoothReactivePage extends StatefulWidget {
//   @override
//   _BluetoothReactivePageState createState() => _BluetoothReactivePageState();
// }

// class _BluetoothReactivePageState extends State<BluetoothReactivePage> {
//   final flutterReactiveBle = FlutterReactiveBle();
  
//   Future<List<Widget>> scanForDevices(){
//     flutterReactiveBle.scanForDevices(withServices: [], scanMode: ScanMode.lowLatency).listen((device) {
//       //code for handling results
//     }, onError: () {
//       //code for handling error
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
      
//     );
//   }
// }