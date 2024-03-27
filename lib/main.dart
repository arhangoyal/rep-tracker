import 'package:flutter/material.dart';
import 'package:flutter_blue_app/MainPage.dart';


void main() => runApp(new ExampleApplication());

class ExampleApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          useMaterial3: true, // enable Material 3
          primarySwatch: Colors.blue,
        ),
      home: MainPage());
  }
}