import 'package:flutter/material.dart';
import 'package:DesafioxBardas/Pregunta.dart';

class MostrarPregunta extends StatelessWidget {
  final Pregunta pregunta;

  MostrarPregunta({Key key, @required this.pregunta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool correcto = pregunta.respondioCorrecto == 1;
    String respuestaCorrecta = pregunta.respuestaCorrecta;
    print(pregunta.respondioCorrecto);
    return Scaffold(
      appBar: AppBar(
        title: correcto
            ? Text("Muy bien hecho!")
            : Text(
                "A estudiar!",
                style: TextStyle(color: Colors.white),
              ),
        backgroundColor: correcto ? Colors.green : Colors.red,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Flexible(
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: correcto ? Colors.green[200] : Colors.red[200]),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    pregunta.pregunta,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Text(
              "\nRespuesta correcta: \n",
              style: TextStyle(fontFamily: 'LexendDeca', fontSize: 20.0),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                respuestaCorrecta,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22.0, fontFamily: 'LexendDeca'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
