import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:uflow_app/main.dart';
import 'package:provider/provider.dart';


class DataSample {
  double emg1;
  double emg2;
  DateTime timestamp;

  DataSample({
    this.emg1,
    this.emg2,
    this.timestamp,
  });
}

class BackgroundCollectingTask extends Model {
  static BackgroundCollectingTask of(
    BuildContext context, {
    bool rebuildOnChange = false,
  }) =>
      ScopedModel.of<BackgroundCollectingTask>(
        context,
        rebuildOnChange: rebuildOnChange,
      );

  final BluetoothConnection _connection;
  List<int> _buffer = List<int>();

  // @TODO , Such sample collection in real code should be delegated
  // (via `Stream<DataSample>` preferably) and then saved for later
  // displaying on chart (or even stright prepare for displaying).
  // @TODO ? should be shrinked at some point, endless colleting data would cause memory shortage.
  List<DataSample> samples = List<DataSample>();

  bool inProgress;

  List<int> myBuffer = [];

  int emg1Data;

  int emg2Data;

  BackgroundCollectingTask._fromConnection(this._connection, BuildContext context) {
    _connection.input.listen((data) {
      myBuffer += data;
      // print('-----Data recieved-----');
      // print('Number of bytes: ${data.length}');
      // print('Data: $data');
      // print('Buffer length: ${myBuffer.length}');
      _buffer += data;
      

      if(myBuffer.length > 6){
        myBuffer.clear();
      } else if (myBuffer.length == 6){

        emg1Data = int.parse(AsciiDecoder().convert(myBuffer.sublist(0, 3)));
        emg2Data = int.parse(AsciiDecoder().convert(myBuffer.sublist(3, 6)));
        // print(myBuffer);
        print('EMG1: ${ascii.decode(myBuffer.sublist(0, 3))}');
        print('EMG2: ${ascii.decode(myBuffer.sublist(3, 6))}');
        myBuffer.clear();
        var currentData = Provider.of<EMGData>(context, listen: false);
        currentData.emg1 = emg1Data;
        currentData.emg2 = emg2Data;
      }

      // while (true) {
      //   // If there is a sample, and it is full sent
      //   int index = _buffer.indexOf('t'.codeUnitAt(0));
      //   if (index >= 0 && _buffer.length - index >= 5) {
      //     final DataSample sample = DataSample(
      //         emg1: (_buffer[index + 1] + _buffer[index + 2] / 100),
      //         emg2: (_buffer[index + 3] + _buffer[index + 4] / 100),
      //         timestamp: DateTime.now());
      //     _buffer.removeRange(0, index + 5);

      //     samples.add(sample);
      //     notifyListeners(); // Note: It shouldn't be invoked very often - in this example data comes at every second, but if there would be more data, it should update (including repaint of graphs) in some fixed interval instead of after every sample.
      //     //print("${sample.timestamp.toString()} -> ${sample.temperature1} / ${sample.temperature2}");
      //   }
      //   // Otherwise break
      //   else {
      //     break;
      //   }
      // }
    }).onDone(() {
      inProgress = false;
      notifyListeners();
    });
  }

  static Future<BackgroundCollectingTask> connect(
      BluetoothDevice server, BuildContext context) async {
        print('BLUETOOTH: Starting Connection...');
    final BluetoothConnection connection =
        await BluetoothConnection.toAddress(server.address);
        print('BLUETOOTH: Finished Connection');
    return BackgroundCollectingTask._fromConnection(connection, context);
  }

  void dispose() {
    _connection.dispose();
  }

  Future<void> start() async {
    inProgress = true;
    _buffer.clear();
    samples.clear();
    notifyListeners();
    _connection.output.add(ascii.encode('start'));
    await _connection.output.allSent;
  }

  Future<void> cancel() async {
    inProgress = false;
    notifyListeners();
    _connection.output.add(ascii.encode('stop'));
    await _connection.finish();
  }

  Future<void> pause() async {
    inProgress = false;
    notifyListeners();
    _connection.output.add(ascii.encode('stop'));
    await _connection.output.allSent;
  }

  Future<void> reasume() async {
    inProgress = true;
    notifyListeners();
    _connection.output.add(ascii.encode('start'));
    await _connection.output.allSent;
  }

  Iterable<DataSample> getLastOf(Duration duration) {
    DateTime startingTime = DateTime.now().subtract(duration);
    int i = samples.length;
    do {
      i -= 1;
      if (i <= 0) {
        break;
      }
    } while (samples[i].timestamp.isAfter(startingTime));
    return samples.getRange(i, samples.length);
  }
}