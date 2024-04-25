import 'package:flutter/material.dart';
import 'package:rep_tracker/HealthReport.dart';
import 'package:rep_tracker/HealthReportLDL.dart';
import 'package:rep_tracker/HealthReportHDL.dart';
import 'package:rep_tracker/HealthReportTrig.dart';

class ReportPageSubMenu extends StatefulWidget {
  @override
  _ReportPageSubMenu createState() => new _ReportPageSubMenu();
}


class _ReportPageSubMenu extends State<ReportPageSubMenu> {
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
            backgroundColor: Color.fromARGB(255, 216, 212, 250),
      appBar: AppBar(
        title: const Text('Display Health Graphs',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Color.fromARGB(255, 90, 187, 158), Color.fromARGB(255, 138, 120, 238)])),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: ElevatedButton(
                child: const Text('Graph of Weight Vs Date'),
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                      color: Color.fromARGB(255, 134, 108, 173), width: 0.75),
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontStyle: FontStyle.normal),
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(17))),
                ),
                onPressed: () async {
                  _weightDateReport(context);
                },
              ),
            ),
            ListTile(
              title: ElevatedButton(
                child: const Text('Graph of LDL Vs Date'),
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                      color: Color.fromARGB(255, 134, 108, 173), width: 0.75),
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontStyle: FontStyle.normal),
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(17))),
                ),
                onPressed: () async {
                  _ldlDateReport(context);
                },
              ),
            ),
            ListTile(
              title: ElevatedButton(
                child: const Text('Graph of HDL Vs Date'),
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                      color: Color.fromARGB(255, 134, 108, 173), width: 0.75),
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontStyle: FontStyle.normal),
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(17))),
                ),
                onPressed: () async {
                  _hdlDateReport(context);
                },
              ),
            ),
            ListTile(
              title: ElevatedButton(
                child: const Text('Graph of Triglyclerides Vs Date'),
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                      color: Color.fromARGB(255, 134, 108, 173), width: 0.75),
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontStyle: FontStyle.normal),
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(17))),
                ),
                onPressed: () async {
                  _trigDateReport(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _weightDateReport(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return HealthReport();
        },
      ),
    );
  }

  void _ldlDateReport(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return HealthReportLDL();
        },
      ),
    );
  }

  void _hdlDateReport(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return HealthReportHDL();
        },
      ),
    );
  }

  void _trigDateReport(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return HealthReportTrig();
        },
      ),
    );
  }
}
