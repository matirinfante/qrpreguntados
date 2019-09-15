import 'package:flutter/material.dart';
import 'package:animated_splash/animated_splash.dart';
import 'package:DesafioxBardas/Historial.dart';
import 'package:DesafioxBardas/Index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

void main() {
  Function verificarCodigo = () async {
    SystemChrome.setEnabledSystemUIOverlays([]);

    final prefs = await SharedPreferences.getInstance();
    bool res = prefs.getBool('inicioCarrera') ?? false;
    print(res);
    return res;
  };

  Map<dynamic, Widget> op = {true: Historial(), false: Index()};

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MaterialApp(
      title: 'DesafioxBardas',
      home: AnimatedSplash(
        imagePath: 'assets/loading.gif',
        home: Historial(),
        duration: 5000,
        type: AnimatedSplashType.BackgroundProcess,
        customFunction: verificarCodigo,
        outputAndHome: op,
      ),
      debugShowCheckedModeBanner: false,
    ));
  });
}
