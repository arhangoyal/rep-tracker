import 'package:rep_tracker/SqliteHealth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class HealthPage extends StatefulWidget {
  @override
  _HealthPage createState() => new _HealthPage();
}

class _HealthPage extends State<HealthPage> {
  final SqliteService dbManager = new SqliteService();

  //final DbManager dbManager = new DbManager();
  HealthData model;
  List<HealthData> modelList;
  TextEditingController dateTextController = TextEditingController();
  TextEditingController weightTextController = TextEditingController();
  TextEditingController ldlTextController = TextEditingController();
  TextEditingController hdlTextController = TextEditingController();
  TextEditingController trigTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 230, 214, 227),
      appBar: AppBar(
        title: const Text('Health Parameters APP',
        style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 243, 221, 241))),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.red, Colors.blue])),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.health_and_safety_outlined),
        label: const Text('Click here to enter your Health Parameters', style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 212, 4, 195)) ),
        backgroundColor: Color.fromARGB(198, 248, 190, 248),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Enter Health Data"),
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
                           
                            }
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).unfocus();
        
                          },
                        ),
                   
                        TextFormField(
                          controller: weightTextController,
                          keyboardType: TextInputType.number,
                    
                          decoration: InputDecoration(hintText: "enter Weight"),
                          onFieldSubmitted: (value) {
                      
                            print(weightTextController);
                          },
                        ),
                        TextFormField(
                          controller: ldlTextController,
                          keyboardType: TextInputType.number,
                
                          decoration: InputDecoration(hintText: "enter LDL"),
                          onFieldSubmitted: (value) {
             
                          },
                        ),
                        TextFormField(
                          controller: hdlTextController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: "enter HDL"),
                          onFieldSubmitted: (value) {
                          },
                        ),
                        TextFormField(
                          controller: trigTextController,
                          keyboardType: TextInputType.number,
                          decoration:
                              InputDecoration(hintText: "enter Triglycerides"),
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
                      onPressed: () async {
                        //onPressed();

                    print(dateTextController.text);
                    print(weightTextController);
                    print(dateTextController);
                    HealthData model = new HealthData(
                        date: dateTextController.text,
                        weight: double.parse(weightTextController.text),
                        ldl: double.parse(ldlTextController.text),
                        hdl: double.parse(hdlTextController.text),
                        trig: double.parse(trigTextController.text));
                    int id = await dbManager.createItem(model);
                    print("data inserted  ${id}");
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        dateTextController.text = "";
                        weightTextController.text = "";
                        ldlTextController.text = "";
                        hdlTextController.text = "";
                        trigTextController.text = "";
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
            modelList = snapshot.data as List<HealthData>;
            return ListView.builder(
              itemCount: modelList.length,
              itemBuilder: (context, index) {
                HealthData _model = modelList[index];
                return ItemCard(
                  model: _model,
                  dateTextController: dateTextController,
                  weightTextController: weightTextController,
                  ldlTextController: ldlTextController,
                  hdlTextController: hdlTextController,
                  trigTextController: trigTextController,
                  onDeletePress: () {
                    dbManager.deleteData(_model);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {});
                    });
                  },
                  onEditPress: () {
                    dateTextController.text = _model.date ?? "";
                    weightTextController.text = _model.weight.toString() ?? "";
                    ldlTextController.text = _model.ldl.toString() ?? "";
                    hdlTextController.text = _model.hdl.toString() ?? "";
                    trigTextController.text = _model.trig.toString() ?? "";
                    showDialog(
                        context: context,
                        builder: (context) {
                          return DialogBox().dialog(
                            context: context,
                            onPressed: () {
                              HealthData __model = HealthData(
                                  date: dateTextController.text,
                                  weight:
                                      double.parse(weightTextController.text),
                                  ldl: double.parse(ldlTextController.text),
                                  hdl: double.parse(hdlTextController.text),
                                  trig: double.parse(trigTextController.text));
                              dbManager.updateData(__model);
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  dateTextController.text = "";
                                  weightTextController.text = "";
                                  ldlTextController.text = "";
                                  hdlTextController.text = "";
                                  trigTextController.text = "";
                                });
                              });

                              Navigator.of(context).pop();
                            },

                            dateInput: dateTextController,
                            textEditingController2: weightTextController,
                            textEditingController3: ldlTextController,
                            textEditingController4: hdlTextController,
                            textEditingController5: trigTextController,

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
 
    return AlertDialog(
      title: Text("Enter Health Data"),
      content: Container(
        height: 330,
        child: Column(
          children: [

            TextFormField(
              controller: dateInput,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(hintText: "Enter Date "),
              onFieldSubmitted: (value) {
              },
            ),
            TextFormField(
              controller: textEditingController2,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "enter Weight"),
              onFieldSubmitted: (value) {
                print(textEditingController2);
              },
            ),
            TextFormField(
              controller: textEditingController3,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "enter LDL"),
              onFieldSubmitted: (value) {
              },
            ),
            TextFormField(
              controller: textEditingController4,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "enter HDL"),
              onFieldSubmitted: (value) {
              },
            ),
            TextFormField(
              controller: textEditingController5,
              keyboardType: TextInputType.number,
              //focusNode: ageTextFocusNode,
              decoration: InputDecoration(hintText: "enter Triglycerides"),
              onFieldSubmitted: (value) {
                //  ageTextFocusNode?.unfocus();
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
  HealthData model;
  TextEditingController dateTextController;
  TextEditingController weightTextController;
  TextEditingController ldlTextController;
  TextEditingController hdlTextController;
  TextEditingController trigTextController;
  Function onDeletePress;
  Function onEditPress;

  ItemCard(
      {this.model,
      this.dateTextController,
      this.weightTextController,
      this.ldlTextController,
      this.hdlTextController,
      this.trigTextController,
      this.onDeletePress,
      this.onEditPress});

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  final SqliteService dbManager = new SqliteService();

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
                    'Weight: ${widget.model.weight}',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'LDL: ${widget.model.ldl}',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'HDL: ${widget.model.hdl}',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'Triglycerides: ${widget.model.trig}',
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
