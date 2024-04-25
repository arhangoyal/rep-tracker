import 'package:flutter/material.dart';
import 'package:rep_tracker/ExerciseSelection.dart';
import 'package:rep_tracker/UserPage.dart';
import 'package:rep_tracker/ReportPage.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => new _MainPage();
}

class _MainPage extends State<MainPage> {
  bool connected = false;
  BluetoothDevice _device;

  @override
  void initState() {
    super.initState();

    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) {
      setState(() {
        for (BluetoothDevice device in bondedDevices) {
          if (device.name == "raspberrypi") {
            _device = device;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 233, 217, 234),
      appBar: AppBar(
        title: Align(
            alignment: Alignment.center,
            child: Text('REP TRACKER',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white))),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.red, Colors.blue])),
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Divider(),
            ListTile(
                title: Text("Bluetooth Connected to Device: " +
                    (_device == null ? "..." : _device.name))),
            ListTile(
              title: ElevatedButton(
                child: const Text('Start Exercise'),
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                      color: Color.fromARGB(255, 158, 26, 198), width: 0.75),
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontStyle: FontStyle.normal),
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                onPressed: () async {
                  if (_device != null) {
                    print('Connect -> selected ' + _device.address);
                    _startExerciseApp(context, _device);
                  } else {
                    ListTile(title: Text("Connect -> no device selected"));
                  }
                },
              ),
            ),
            ListTile(
              title: ElevatedButton(
                child: const Text('Enter User Info'),
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                      color: Color.fromARGB(255, 158, 26, 198), width: 0.75),
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontStyle: FontStyle.normal),
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                onPressed: () async {
                  _startUserApp(context, _device);
              
                },
              ),
            ),
            ListTile(
              title: ElevatedButton(
                child: const Text('Reports'),
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                      color: Color.fromARGB(255, 158, 26, 198), width: 0.75),
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontStyle: FontStyle.normal),
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                onPressed: () async {
                  _startReportsApp(context, _device);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startExerciseApp(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ExerciseSelection(server: server);
        },
      ),
    );
  }

  void _startUserApp(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return UserPage();
        },
      ),
    );
  }

  void _startReportsApp(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ReportPage();
        },
      ),
    );
  }
  
}
