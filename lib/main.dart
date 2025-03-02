import 'package:flutter/material.dart';
import 'Screen/AppScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'iLuvMusik',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: AppScreen(), // Ensure this is the root widget
    );
  }
}
