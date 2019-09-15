import 'package:flutter/material.dart';

class Puntaje extends InheritedWidget {
  int puntaje;

  Puntaje({this.puntaje, Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(Puntaje oldWidget) {
    return puntaje != oldWidget.puntaje;
  }
}
