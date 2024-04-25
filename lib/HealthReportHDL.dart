import 'package:rep_tracker/SqliteHealth.dart';
import 'package:intl/intl.dart' as intl;

import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

class HealthReportHDL extends StatefulWidget {
  @override
  LineChartWidget createState() => new LineChartWidget();
}

List<HealthData> myList = [];

class LineChartWidget extends State<HealthReportHDL> {
  final SqliteService dbManager = new SqliteService();
  final List<HealthData> points = myList;

  Future<List<HealthData>> initDB() async {
    myList = await dbManager.getItems();
  }

  @override
  void initState() {
    initDB();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: dbManager.getItems(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            myList = snapshot.data as List<HealthData>;
            print(myList[0].toMap());
            for (var k = 0; k < myList.length; k++) {
              HealthData ll = myList[k];
              print(ll.hdl);
            }
            return AspectRatio(
              aspectRatio: 2,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: myList
                          .map((point) => FlSpot(
                              DateTime.parse(point.date)
                                  .millisecondsSinceEpoch
                                  .toDouble(),
                              point.hdl))
                          .toList(),
                      isCurved: false,
                      dotData: FlDotData(
                        show: true,
                      ),
                    ),
                  ],
                  borderData: FlBorderData(
                      show: true,
                      border: const Border(
                          bottom: BorderSide(width: 2),
                          left: BorderSide(width: 2),
                          right: BorderSide(width: 2),
                          top: BorderSide(width: 2))),

                  titlesData: FlTitlesData(
                    bottomTitles: getBottomTitles(),
                    topTitles: getTopTitles(),
                    leftTitles: getLeftTitles(),
                    rightTitles: getRightTitles(),
                  ),
                  //*/
                ),
              ),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  AxisTitles getTopTitles() {
    print("in toptiles");
    return AxisTitles(
    
      axisNameWidget: Text("Plot of HDL Vs Date", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13, backgroundColor: Colors.blue.shade600)),
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta ) => Container(), 
        reservedSize: 25,
      ),
    );
  }
  AxisTitles getRightTitles() {
    print("in righttiles");
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta ) => Container(), 
        reservedSize: 40,
      ),
    );
  }
  AxisTitles getLeftTitles() {
    print("in lefttiles");
    return AxisTitles(
      axisNameWidget: Text ("HDL", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12, backgroundColor: Colors.blue.shade600)),
      sideTitles: SideTitles(
        interval: 3,
        showTitles: true,
        reservedSize: 20,
        getTitlesWidget: (value, meta) {
          
          print(value);
          String text = '';
          int intVal = value.toInt();
          for (var i=0; i < myList.length; i++)
          {
            if ((intVal == myList[i].hdl) | (intVal == 0)) {
              print ("in intval = mylist");
              print (intVal);
               text = intVal.toString();
            }
          }

          return Text(text);
        },
      ),
    );
  }

  AxisTitles getBottomTitles() {
    print("in bottomtiles");
    return AxisTitles(
      axisNameWidget: Text("Date", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12, backgroundColor: Colors.blue.shade600)),
      sideTitles: SideTitles(
        interval: (DateTime.parse(myList.last.date)
                    .millisecondsSinceEpoch
                    .toDouble() -
                DateTime.parse(myList.first.date)
                    .millisecondsSinceEpoch
                    .toDouble()) /
            2,
        showTitles: true,
        getTitlesWidget: (value, meta) {
          String text = '';
          DateTime dt = DateTime.fromMillisecondsSinceEpoch(value.toInt());
          intl.DateFormat dateFormat = intl.DateFormat("yyyy-MM-dd");
          text = dateFormat.format(dt);

          print(text);

          return Text(text);
        },
      ),
    );
  }
}
