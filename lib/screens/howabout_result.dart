import 'package:flutter/material.dart';
import '../constants.dart';

class HowAboutResult extends StatefulWidget {
  final String catalog;
  final String option;

  HowAboutResult({this.catalog, this.option});

  @override
  _HowAboutResultState createState() => _HowAboutResultState();
}

class _HowAboutResultState extends State<HowAboutResult> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.5,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Scaffold(
              body: SafeArea(
                child: Container(
                  child: Center(
                    child: Text(''),
                  ),
                ),
              ),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("'이거닷!!'",
                style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    fontSize: 60)),
            SizedBox(
              height: 50,
            ),
            Container(
              child: Center(
                child: Text(
                  widget.catalog,
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      color: kTealColor,
                      fontSize: 60),
                ),
              ),
            ),
            Container(
              child: Center(
                child: Text(
                  widget.option,
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      color: kTealColor,
                      fontSize: 40),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
