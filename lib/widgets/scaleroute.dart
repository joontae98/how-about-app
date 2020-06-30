import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'frosttransiton.dart';

class ScaleRoute extends PageRouteBuilder {
  @override
  bool get opaque => false;

  final Widget page;

  ScaleRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.fastOutSlowIn,
              ),
            ),
            child: FrostTransition(
              animation: new Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(animation),
              child: child,
            ),
          ),
        );
}
