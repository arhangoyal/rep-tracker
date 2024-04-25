import 'package:flutter/material.dart';
import 'package:rep_tracker/MainPage.dart';


void main() => runApp(new ExampleApplication());

class ExampleApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true, // enable Material 3
          primarySwatch: Colors.blue,
        ),
      home: MainPage());
  }
}