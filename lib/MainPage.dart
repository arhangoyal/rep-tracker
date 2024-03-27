import 'package:flutter/material.dart';
import 'package:flutter_blue_app/AppPage.dart';
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
        for(BluetoothDevice device in bondedDevices){
          if (device.name == "raspberrypi"){
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
      appBar: AppBar(
        title: const Text('PiCar Remote Control App'),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Divider(),
            ListTile(title: Text("Device: " + (_device == null? "..." : _device.name))),
            ListTile(
              title: ElevatedButton(
                child: const Text('Start PiCar Control'),
                onPressed: () async {
                  if (_device != null) {
                    print('Connect -> selected ' + _device.address);
                    _startApp(context, _device);
                  } else {
                    ListTile(title: Text("Connect -> no device selected"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _startApp(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return AppPage(server: server);
        },
      ),
    );
  }
  /*
  void _startChat(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ChatPage(server: server);
        },
      ),
    );
  }
  */
}
