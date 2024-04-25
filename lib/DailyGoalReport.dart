import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rep_tracker/SQLiteExerciseDone.dart';

class DailyGoalReport extends StatefulWidget {

  @override
  _DailyGoalReport createState() => new _DailyGoalReport();
}


class _DailyGoalReport extends State<DailyGoalReport> {
 
  final SqliteServiceExerciseDone dbManager = new SqliteServiceExerciseDone();
  List<ExerciseDone> exerciseDone;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    this.getData();
    
  }


Future getData () async {
    exerciseDone = await dbManager.getItems();

setState(() {
  loading = false;
});
  print('${exerciseDone.length}');
 
 }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return CircularProgressIndicator();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 235, 217, 246),
          title: const Text('Daily Goal Chart',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Color.fromARGB(255, 101, 20, 241), Color.fromARGB(255, 239, 161, 228)])),
        ),
          ),
      body: SafeArea(

        child: Column(
          children: <Widget>[
          SizedBox(height: 10),
          Container(
                //width: 242,
                decoration: BoxDecoration(border: Border.all()),
                child: Text('View how you have performed', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20, backgroundColor: Color.fromARGB(255, 179, 1, 116)))
            ),
            SizedBox(height: 15),
            DataTable(
              columnSpacing: 20,
                columns: [
                  DataColumn(
                      label: SizedBox(width: 30,
                      child: Text('Date',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade100)))),
                  DataColumn(
                      label: Text('Exercise',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade100))
                              ),
                  DataColumn(
                      //label: SizedBox(width: 20,
                      label: Container(
                        width: 45,
                        child: Text('Reps Target',
                        overflow: TextOverflow.visible,
                        softWrap: true,
                          style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              color: Colors.purple.shade100))
                      ), 
                              numeric: true),
                   DataColumn(
                      //label: SizedBox(width: 20,
                      label: Container(
                        width: 35,
                        child: Text('Reps Done',
                        overflow: TextOverflow.visible,
                        softWrap: true,
                          style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              color: Colors.purple.shade100))
                      ), 
                              numeric: true), 
                    DataColumn(
                      label: Text('Outcome',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade100))
                              ),  
                ],
                
                rows: exerciseDone.map<DataRow>((element) => DataRow(cells: [
                  DataCell(Container(width: 40, child: Text(element.date))),
                  DataCell(Container(width: 40, child: Text(element.exercise))),
                  DataCell(Text(element.totalRepTarget.toString())),
                  DataCell(Container(child: Text(element.totalRepDone.toString()))),
                  DataCell(Text(element.success)),
                ])).toList(),
                
                showBottomBorder: true,
                headingRowColor: MaterialStateProperty.resolveWith(
                    (states) => Color.fromARGB(255, 175, 0, 218)),
                border: TableBorder.all(
                  width: 3.0,
                  color: Colors.pink.shade200,
                )),
            SizedBox(
              //Use of SizedBox
              height: 50,
              
            ),
          ],
        ),

      ),
    );
  }

 
}
