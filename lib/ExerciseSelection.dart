import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:rep_tracker/SqliteDailyGoal.dart';
import 'package:rep_tracker/SqliteExerciseDone.dart';
import 'package:intl/intl.dart';

class ExerciseSelection extends StatefulWidget {
  final BluetoothDevice server;

  const ExerciseSelection({this.server});

  @override
  _ExerciseSelection createState() => new _ExerciseSelection();
}

class _ExerciseSelection extends State<ExerciseSelection> {
  BluetoothDevice _device;
  BluetoothConnection connection;

  final SqliteServiceDailyGoal dbManager = new SqliteServiceDailyGoal();
  final SqliteServiceExerciseDone dbManagerExercise =
      new SqliteServiceExerciseDone();

  String _messageBuffer = '';
  String message = "";
  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;
  bool isDisconnecting = false;
  String exerciseSuccess = "Waiting for you to select your exercise!";
  bool isLoading = true;
  final List<String> list1 = ["PushUp", "Squat"];
  bool isSuccess = false;
  // the selected value
  String _selectedDropDown = "";

  DailyGoalData model;
  List<DailyGoalData> modelList;
  List<ExerciseDone> value2;
  ExerciseDone exerciseDone;
  TextEditingController dateTextController = TextEditingController();
  TextEditingController exerciseTextController = TextEditingController();
  TextEditingController totalRepGoalTextController = TextEditingController();
  TextEditingController repsPerSetGoalTextController = TextEditingController();
  int id_1;
  @override
  void initState() {
    super.initState();
    _selectedDropDown = list1.first;

    

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      ListTile(title: Text("Connected to the device"));
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection.input.listen(_onDataReceived).onDone(() {

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

    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    
    List readings = [];
    String exerDate = " ";
    String exerName = " ";
    String exerTime;
    String exerTarget;
    String exerCount;
    String exerSuccess;
    if (message.isNotEmpty) {
      print("in messaage not empty");
      readings = message.split(" ");
      exerDate = readings[0];
      exerName = readings[1];
      exerTime = readings[2];
      exerTarget = readings[3];
      exerCount = readings[4];
      exerSuccess = readings[5];
      print(exerDate);
      print(exerName);
      print(exerTime);
      print(exerTarget);
      print(exerCount);
      print(exerSuccess);
      if (exerSuccess == "PASS") {
        isSuccess = true;
      } 

      exerciseDone = new ExerciseDone(
          date: exerDate,
          timeTaken: exerTime,
          exercise: exerName,
          totalRepTarget: int.parse(exerTarget),
          totalRepDone: int.parse(exerCount),
          success: exerSuccess);
      
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Exercise to do',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: <Color>[
                Color.fromARGB(255, 72, 205, 231),
                Color.fromARGB(255, 6, 174, 51)
              ])),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 140.0),
        child: FloatingActionButton.extended(
          icon: const Icon(Icons.health_and_safety_rounded),
          elevation: 40,
          label: const Text('Click Here to Start Exercise',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 1, 136, 82))),
          backgroundColor: Color.fromARGB(197, 147, 248, 172),

          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  
                  String abcd;
                  return AlertDialog(
                    title: Text("Select your Exercise"),
                    content: Container(
                      height: 330,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: dateTextController,
                            decoration: InputDecoration(
                                icon: Icon(
                                    Icons.calendar_today), //icon of text field
                                labelText: "Enter Date" //label text of field
                                ),
                            readOnly: true,
                            onTap: () async {
                              DateTime pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2023),
                                  lastDate: DateTime(2025));
                              if (pickedDate != null) {
                                print(
                                    pickedDate); 
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(formattedDate);
                                setState(() {
                                  dateTextController.text = formattedDate;
                                });
                                abcd = formattedDate;
                              }
                            },
                            onFieldSubmitted: (value) {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                          DropdownButtonFormField<String>(
                            value: _selectedDropDown,
   
                            style: const TextStyle(color: Colors.deepPurple),

                            hint: const Center(
                                child: Text(
                              'Select the exercise',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 118, 21, 21)),
                            )),

                            // set the color of the dropdown menu
                            dropdownColor: Colors.amber,
                            icon: const Icon(
                              Icons.arrow_downward,
                              color: Color.fromARGB(255, 34, 7, 236),
                            ),
                            isExpanded: true,

                            items: list1.map((String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String value) {
                              // This is called when the user selects an item.
                              setState(() {
                                _selectedDropDown = value;
                                abcd = value;
                                exerciseTextController.text = value;
                              });
                            },
                          ),
                          
                        ],
                      ),
                    ),
                    actions: [
                      MaterialButton(
                        onPressed: () {
                          print("(D((D(D(((((((((&&&&)))))))))))))");
                          Navigator.of(context).pop();
                        },
                        color: Colors.blue,
                        child: Text(
                          "Cancel",
                        ),
                      ),
                      MaterialButton(
                        onPressed: () async {
                          setState(() {
                            CircularProgressIndicator();
                            exerciseSuccess = "You have selected to do " +
                                exerciseTextController.text +
                                ". Now, Waiting for you to complete the exercise!";
                          });
                          Future<List<DailyGoalData>> modelL =
                              dbManager.getItems();
                          List<DailyGoalData> modelLi = await modelL;
                          for (DailyGoalData data in modelLi) {

                            if ((data.date == dateTextController.text) &&
                                (data.exercise ==
                                    exerciseTextController.text)) {
                              int totalGoal = data.totalRepGoal;
                              String toSend = exerciseTextController.text +
                                  " " +
                                  totalGoal.toString() +
                                  " " +
                                  dateTextController.text +
                                  " ";
                              exerciseSuccess = "You have selected to do " + totalGoal.toString() + " reps of " +
                                exerciseTextController.text +
                                ". Now, Waiting for you to complete the exercise!";
                              _sendMessage(toSend);
                            }
                          }

                          Navigator.of(context).pop();
                        } /*onPressed!()*/,
                        child: Text("Save"),
                        color: Colors.blue,
                      )
                    ],
                  );
                });
          },
        ),
      ),
 

      body: FutureBuilder(
        future: dbManagerExercise.createItem(exerciseDone),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            isLoading = false;
          }

          return Center(
              child: isLoading
                  ? Center(
                      child: Text(exerciseSuccess, style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 1, 43, 33), fontSize: 18, backgroundColor: Color.fromARGB(255, 185, 244, 205)),
                    ))
                  : Container(
                      child: isSuccess
                          ? Stack(
                              children: <Widget>[
                                Image.network(
                                    "https://media.tenor.com/GqFuO1-IoD4AAAAi/very-nice.gif", height:200, width:200),
                                Padding(
                                  padding: const EdgeInsets.only(top: 150.0),
                                  child: Text('GOOD JOB! HYDRATE', style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 1, 43, 33), fontSize: 18, backgroundColor: Color.fromARGB(255, 185, 244, 205))),
                                )
                              ],
                            
                            )
                          : Stack(
                              children: <Widget>[
                                Image.network(
                                    "https://media.tenor.com/Gbp8h-dqDHkAAAAi/error.gif"),
                                Padding(
                                  padding: const EdgeInsets.only(top: 370.0),
                                  child: Text('NOT GOOD! Goal not completed',style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 1, 43, 33), fontSize: 18, backgroundColor: Color.fromARGB(255, 243, 6, 61))),
                                )
                              ],
                           
                            ))
              
              );
        },
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
    print("In Send Message");
    text = text.trim();

    if (text.length > 0) {
      print(text);
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
