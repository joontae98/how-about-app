import 'package:flutter/material.dart';
import 'package:how_about_app/screens/howabout_home.dart';
import 'package:how_about_app/widgets/behavior.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child,
        );
      },
      title: '이건어때?',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.black,
        textTheme: TextTheme(
          headline1: TextStyle(
              fontFamily: 'Jua',
              fontWeight: FontWeight.w900,
              color: Colors.black,
              fontSize: 40),
          headline2: TextStyle(
              fontSize: 20, fontFamily: 'Jua', fontWeight: FontWeight.w600,color: Colors.black),
        ),
      ),
      home: HowAboutHome(),
    );
  }
}