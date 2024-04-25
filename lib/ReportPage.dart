import 'package:flutter/material.dart';
import 'package:rep_tracker/DailyGoalReport.dart';
import 'package:rep_tracker/ReportPageSubMenu.dart';

class ReportPage extends StatefulWidget {

  @override
  _ReportPage createState() => new _ReportPage();
}


class _ReportPage extends State<ReportPage> {

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 235, 217, 246),
      appBar: AppBar(
          title: const Text('REPORTS PAGE',
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
        child: ListView(
          children: <Widget>[
          ListTile(
              title: ElevatedButton(
                child: const Text('Daily Goal Report'),
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                      color: Color.fromARGB(255, 147, 93, 235), width: 0.6),
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontStyle: FontStyle.normal),
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14))),
                ),
                onPressed: () async {
                  _dailyGoalReport(context);
                },
              ),
            ),
          ListTile(
              title: ElevatedButton(
                child: const Text('Health Report'),
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                      color: Color.fromARGB(255, 147, 93, 235), width: 0.6),
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontStyle: FontStyle.normal),
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14))),
                ),
                onPressed: () async {
                  _healthReport(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _dailyGoalReport(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return DailyGoalReport();
        },
      ),
    );
  }

    void _healthReport(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ReportPageSubMenu();
        },
      ),
    );
  }

}
