import 'package:rep_tracker/SqliteDailyGoal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyGoalPage extends StatefulWidget {
  @override
  _DailyGoalPage createState() => new _DailyGoalPage();
}

class _DailyGoalPage extends State<DailyGoalPage> {
  final SqliteServiceDailyGoal dbManager = new SqliteServiceDailyGoal();
  final List<String> list1 = ["PushUp", "Squat"];

  // the selected value
  String _selectedDropDown = "";

  DailyGoalData model;
  List<DailyGoalData> modelList;
  TextEditingController dateTextController = TextEditingController();
  TextEditingController exerciseTextController = TextEditingController();
  TextEditingController totalRepGoalTextController = TextEditingController();
  TextEditingController repsPerSetGoalTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDropDown = list1.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 213, 226, 225),
      appBar: AppBar(
        title: const Text('Set Daily Goals',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Color.fromARGB(255, 219, 244, 54),
                Colors.blue
              ])),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.calendar_month),
        label: const Text('Click here to enter your Daily Goals'),
        backgroundColor: Color.fromARGB(197, 98, 239, 180),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                String abcd;
                return AlertDialog(
                  title: Text("Enter Daily Goals"),
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
                                //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2025));
                            //dateInput.text = "2024-11-11";
                            if (pickedDate != null) {
                              print(
                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
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
                            //  ageTextFocusNode?.unfocus();
                          },
                        ),
                        DropdownButtonFormField<String>(
                          value: _selectedDropDown,
                          //icon: const Icon(Icons.arrow_downward),
                          //elevation: 16,
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
                        TextFormField(
                          controller: totalRepGoalTextController,
                          keyboardType: TextInputType.number,
                          //focusNode: ageTextFocusNode,
                          decoration:
                              InputDecoration(hintText: "enter Total Rep Goal"),
                          onFieldSubmitted: (value) {
                            //  ageTextFocusNode?.unfocus();
                            print(totalRepGoalTextController);
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      color: Colors.blue,
                      child: Text(
                        "Cancel",
                      ),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        print(_selectedDropDown);
                        DailyGoalData model = new DailyGoalData(
                            date: dateTextController.text,
                            exercise: exerciseTextController.text,
                            totalRepGoal:
                                int.parse(totalRepGoalTextController.text),);
                        int id1 = await dbManager.createItem(model);
                        print("data inserted  ${id1}");
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            dateTextController.text = "";
                            exerciseTextController.text = "";
                            totalRepGoalTextController.text = "";
                          });
                          Navigator.of(context).pop();
                        });
                        
                      } /*onPressed!()*/,
                      child: Text("Save"),
                      color: Colors.blue,
                    )
                  ],
                );
              });
        },
   
      ),
      body: FutureBuilder(
        future: dbManager.getItems(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            modelList = snapshot.data as List<DailyGoalData>;
            return ListView.builder(
              itemCount: modelList.length,
              itemBuilder: (context, index) {
                DailyGoalData _model = modelList[index];
                return ItemCard(
                  model: _model,
                  dateTextController: dateTextController,
                  exerciseTextController: exerciseTextController,
                  totalRepTextController: totalRepGoalTextController,
                  onDeletePress: () {
                    dbManager.deleteData(_model);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {});
                    });
                  },
                  onEditPress: () {
                    dateTextController.text = _model.date ?? "";
                    exerciseTextController.text = _model.exercise ?? "";
                    totalRepGoalTextController.text =
                        _model.totalRepGoal.toString() ?? "";
                    showDialog(
                        context: context,
                        builder: (context) {
                          return DialogBox().dialog(
                            context: context,
                            onPressed: () {
                              DailyGoalData __model = DailyGoalData(
                                date: dateTextController.text,
                                exercise: exerciseTextController.text,
                                totalRepGoal:
                                    int.parse(totalRepGoalTextController.text),
                              );
                              dbManager.updateData(__model);
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  dateTextController.text = "";
                                  exerciseTextController.text = "";
                                  totalRepGoalTextController.text = "";
                                });
                              });

                              Navigator.of(context).pop();
                            },

                            dateInput: dateTextController,
                            textEditingController2: exerciseTextController,
                            textEditingController3: totalRepGoalTextController,
                          );
                        });
                  },
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

const List<String> list = <String>['PushUp', 'Squat'];
String dropdownValue = list.first;

class DialogBox {
  DateTime date2;
  DateTime selectedDate = DateTime.now();
  String stringDate = "";
  TextEditingController dateInput = TextEditingController();

  Widget dialog({
    BuildContext context,
    Function onPressed,
    TextEditingController dateInput,
    TextEditingController textEditingController2,
    TextEditingController textEditingController3,
    TextEditingController textEditingController4,
    TextEditingController textEditingController5,

    String abcd,
   
  }) {
    //dateInput = TextEditingController();
    return AlertDialog(
      title: Text("Enter Daily Goals"),
      content: Container(
        height: 330,
        child: Column(
          children: [
            TextFormField(
              controller: dateInput,
              keyboardType: TextInputType.text,
           
              decoration: InputDecoration(hintText: "Enter Date "),
              /*autofocus: true,*/
              onFieldSubmitted: (value) {
        
              },
            ),
            DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String value) {
                dropdownValue = value;
                abcd = value;
              },
              items: list
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            e,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ))
                  .toList(),
        
            ),
            TextFormField(
              controller: textEditingController2,
              keyboardType: TextInputType.text,
             
              decoration: InputDecoration(hintText: "enter Exercise"),
              onFieldSubmitted: (value) {
           
                print(textEditingController2);
              },
            ),
            TextFormField(
              controller: textEditingController3,
              keyboardType: TextInputType.number,
             
              decoration: InputDecoration(hintText: "enter Total Rep Goal"),
              onFieldSubmitted: (value) {
                
              },
            ),
            
          ],
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.blue,
          child: Text(
            "Cancel",
          ),
        ),
        MaterialButton(
          onPressed: () {
            onPressed();
          } /*onPressed!()*/,
          child: Text("Save"),
          color: Colors.blue,
        )
      ],
    );
  }
}

class ItemCard extends StatefulWidget {
  DailyGoalData model;
  TextEditingController dateTextController;
  TextEditingController exerciseTextController;
  TextEditingController totalRepTextController;
  TextEditingController repsPerSetGoalTextController;

  Function onDeletePress;
  Function onEditPress;

  ItemCard(
      {this.model,
      this.dateTextController,
      this.exerciseTextController,
      this.totalRepTextController,
      this.onDeletePress,
      this.onEditPress});

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  final SqliteServiceDailyGoal dbManager = new SqliteServiceDailyGoal();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Date: ${widget.model.date}',
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    'Exercise: ${widget.model.exercise}',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'Total Reps Goal: ${widget.model.totalRepGoal}',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      onPressed: () {
                        widget.onEditPress();
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      onPressed: () {
                        widget.onDeletePress();
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
