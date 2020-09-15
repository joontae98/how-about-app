import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:how_about_app/services/admob_service.dart';
import '../constants.dart';

class HowAboutResult extends StatefulWidget {
  final String catalog;
  final String option;
  final ams = AdMobService();

  HowAboutResult({this.catalog, this.option});

  @override
  _HowAboutResultState createState() => _HowAboutResultState();
}

class _HowAboutResultState extends State<HowAboutResult> {
  @override
  Widget build(BuildContext context) {
    InterstitialAd newResultAd = widget.ams.getResultInterstitial();
    newResultAd.load();

    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.5,
          child: GestureDetector(
            onTap: () async {
              await newResultAd.show(
                anchorType: AnchorType.bottom,
                anchorOffset: 0.0,
                horizontalCenterOffset: 0.0,
              );
              Navigator.pop(context);
            },
            child: Scaffold(
              body: SafeArea(
                child: Container(),
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
                  textAlign: TextAlign.center, //text center align
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      color: kTealColor,
                      fontSize: 60),
                ),
              ),
            ),
            SizedBox(
              height: 20,
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
