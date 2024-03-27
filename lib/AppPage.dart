import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_svg/flutter_svg.dart';

const String svgStringRight = '''
<svg xmlns="http://www.w3.org/2000/svg" width="36" height="36" fill="currentColor" class="bi bi-caret-right-square-fill" viewBox="0 0 16 16">
  <path d="M0 2a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2zm5.5 10a.5.5 0 0 0 .832.374l4.5-4a.5.5 0 0 0 0-.748l-4.5-4A.5.5 0 0 0 5.5 4z"/>
</svg>
''';

const String svgStringFwd = '''
<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-caret-up-square-fill" viewBox="0 0 16 16">
  <path d="M0 2a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2zm4 9h8a.5.5 0 0 0 .374-.832l-4-4.5a.5.5 0 0 0-.748 0l-4 4.5A.5.5 0 0 0 4 11"/>
</svg>
''';
const String svgStringBack = '''
<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-caret-down-square-fill" viewBox="0 0 16 16">
  <path d="M0 2a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2zm4 4a.5.5 0 0 0-.374.832l4 4.5a.5.5 0 0 0 .748 0l4-4.5A.5.5 0 0 0 12 6z"/>
</svg>
''';

const String svgStringLeft = '''
<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-caret-left-square-fill" viewBox="0 0 16 16">
  <path d="M0 2a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2zm10.5 10V4a.5.5 0 0 0-.832-.374l-4.5 4a.5.5 0 0 0 0 .748l4.5 4A.5.5 0 0 0 10.5 12"/>
</svg>
''';

class AppPage extends StatefulWidget {
  final BluetoothDevice server;

  const AppPage({this.server});

  @override
  _AppPage createState() => new _AppPage();
}

class _AppPage extends State<AppPage> {
  BluetoothConnection connection;

  String _messageBuffer = '';
  String message = "";
  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;
  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      //ListTile(title: Text("Connected to the device"));
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection.input.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final Text command = Text(message);
    String grayscaleRead = "";
    String cputempRead = "";
    String carDirection = "";
    String speedRead = "";
    String distanceRead = "";
    List readings = [];

    var carMoving = {
      'F': 'Forward',
      'B': 'Backward',
      'L': 'Left',
      'R': 'Right',
    };

    if (message.isNotEmpty) {
      readings = message.split(" ");
      grayscaleRead = readings[0] + "," + readings[1] + "," + readings[2];
      cputempRead = readings[3];
      carDirection = carMoving[readings[5]];
      speedRead = readings[6];
      distanceRead = readings[7];
      print(readings[5]);
    }

    print(carDirection);
    final Text grayText = Text(grayscaleRead);
    final Text cpuText = Text(cputempRead);
    final Text carDir = Text(carDirection);
    final Text speed = Text(speedRead);
    final Text distance = Text(distanceRead);

    return Scaffold(
      appBar: AppBar(
        title: Text("PiCar Remote Control",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.red, Colors.blue])),
        ),
        //backgroundColor: Colors.orange.shade100
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
          SizedBox(height: 10),
          Container(
                width: 242,
                decoration: BoxDecoration(border: Border.all()),
                child: Text('Data returned from the PiCar', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18, backgroundColor: Colors.blue.shade600))
            ),
            SizedBox(height: 15),
            DataTable(
                columns: [
                  DataColumn(
                      label: Text('Parameter',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade100))),
                  DataColumn(
                      label: Text('Value',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade100))),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('GrayScale Reading',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800))),
                    DataCell(grayText),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('CPU Temperature',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800))),
                    DataCell(cpuText),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Car Direction',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800))),
                    DataCell(carDir),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Speed (cm/sec)',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800))),
                    DataCell(speed),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Total Distance (cm)',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800))),
                    DataCell(distance),
                  ]),
                ],
                //dividerThickness: 5,
                showBottomBorder: true,
                headingRowColor: MaterialStateProperty.resolveWith(
                    (states) => Colors.pink.shade900),
                border: TableBorder.all(
                  width: 3.0,
                  color: Colors.pink.shade200,
                )),
            SizedBox(
              //Use of SizedBox
              height: 50,
            ),
            Container(
                width: 315,
                decoration: BoxDecoration(border: Border.all()),
                child: Text('Move the car using the buttons below', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade600, fontSize: 18, backgroundColor: Colors.purple.shade50))
            ),
            SizedBox(
              //Use of SizedBox
              height: 20,
            ),
            //command,
            ElevatedButton(
              child: SvgPicture.string(
                svgStringFwd,
                width: 48,
                height: 48,
              ),
              onPressed: () {
                _sendMessage("F");
              },
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    child: SvgPicture.string(
                      svgStringLeft,
                      width: 48,
                      height: 48,
                    ),
                    onPressed: () {
                      _sendMessage("L");
                    },
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    child: SvgPicture.string(
                      svgStringRight,
                      width: 48,
                      height: 48,
                    ),
                    onPressed: () {
                      _sendMessage("R");
                    },
                  ),
                ),
              ],
            ),
            ElevatedButton(
              child: SvgPicture.string(
                svgStringBack,
                width: 48,
                height: 48,
              ),
              onPressed: () {
                _sendMessage("B");
              },
            )
          ],
        ),
      ),
    );
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        message = backspacesCounter > 0
            ? _messageBuffer.substring(
                0, _messageBuffer.length - backspacesCounter)
            : _messageBuffer + dataString.substring(0, index);

        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
    print(_messageBuffer);
  }

  void _sendMessage(String text) async {
    text = text.trim();

    if (text.length > 0) {
      try {
        connection.output.add(utf8.encode(text + "\r\n"));
        await connection.output.allSent;
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}
