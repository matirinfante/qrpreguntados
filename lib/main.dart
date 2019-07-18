import 'package:flutter/material.dart';
import 'package:animated_splash/animated_splash.dart';
import 'Historial.dart';

void main() {
  runApp(MaterialApp(
    home: AnimatedSplash(
      imagePath: '',
      home: Historial(),
      duration: 2500,
      type: AnimatedSplashType.StaticDuration,
    ),
    debugShowCheckedModeBanner: false,
  ));
}
