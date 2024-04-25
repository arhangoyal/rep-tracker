import 'package:flutter/material.dart';
import 'package:rep_tracker/HealthApp.dart';
import 'package:rep_tracker/DailyGoalApp.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPage createState() => new _UserPage();
}

class _UserPage extends State<UserPage> {

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;

  bool isDisconnecting = false;

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
      backgroundColor: Color.fromARGB(255, 213, 226, 225),
      appBar: AppBar(
        title: Align(
            alignment: Alignment.centerLeft,
            child: Text('USER INPUT PAGE',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white))),
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
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: ElevatedButton(
                child: const Text('Enter Daily Goal'),
                  style: ElevatedButton.styleFrom(
                  side: BorderSide(
                      color: Color.fromARGB(255, 89, 220, 235), width: 0.8),
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontStyle: FontStyle.normal),
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
                onPressed: () async {
                  _enterDailyGoal(context);
                },
              ),
            ),
            ListTile(
              title: ElevatedButton(
                child: const Text('Enter Health Parameters'),
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                      color: Color.fromARGB(255, 89, 220, 235), width: 0.8),
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontStyle: FontStyle.normal),
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
                onPressed: () async {
                  _enterHealthParam(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _enterDailyGoal(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return DailyGoalPage();
        },
      ),
    );
  }

  void _enterHealthParam(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return HealthPage();
        },
      ),
    );
  }
  
}
