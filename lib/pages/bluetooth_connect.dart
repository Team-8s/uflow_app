import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class bluetoothPage extends StatefulWidget {
  @override
  _bluetoothPageState createState() => _bluetoothPageState();
}

class _bluetoothPageState extends State<bluetoothPage> {
  FlutterBlue _flutterBlue = FlutterBlue.instance;

  List<Widget> scanResults = [];

  BluetoothDevice uFlowDevice;

  void searchForDevices() async {
    await _flutterBlue.startScan(timeout: Duration(seconds: 6));

    var subscription = _flutterBlue.scanResults.listen((results) {
      // do something with scan results
      setState(() {
        scanResults = [];
      });
      for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi}');
        setState(() {
          scanResults.add(Card(
            child: ListTile(
                title: r.device.name.isNotEmpty
                    ? Text("Device name: ${r.device.name}")
                    : Text("Device name: NOT FOUND"),
                subtitle: Text("Device ID: ${r.device.id.toString()}"),
                trailing: Text("RSSI: ${r.rssi}"),
                onTap: () {
                  print("Connecting to ${r.device.name}...");
                  setState(() {
                    uFlowDevice = r.device;
                    uFlowDevice.connect();
                    uFlowDevice.discoverServices();
                  });
                  

                }),
          ));
        });
      }
    });

    print("SCAN RESULTS: ${scanResults.length}");
    _flutterBlue.stopScan();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          FutureBuilder(
              future: _flutterBlue.connectedDevices,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  print('Got here');
                  List<BluetoothDevice> devices = snapshot.data;
                  // for (BluetoothDevice d in devices) {
                  //   print('Got here');
                  //   print(d.name);
                  // }
                    // uFlowDevice = devices[0];
                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          print(uFlowDevice.services.first.toString());
                        },
                        child: Text('Print services'),
                      ),
                      uFlowDevice != null ? Text(uFlowDevice.name) : Text('No device connected'),
                    ],
                  );
                } else {
                  return Text("No device connected");
                }
              }),
          ElevatedButton(
            onPressed: searchForDevices,
            child: Text('Search for devices'),
          ),
          Column(
            children: scanResults != [] ? scanResults : [Text('Nothing')],
          ),
        ],
      ),
    );
  }
}
