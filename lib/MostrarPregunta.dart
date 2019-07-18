import 'package:flutter/material.dart';
import 'package:QRPreguntados/Pregunta.dart';

class MostrarPregunta extends StatelessWidget {

  final Pregunta pregunta;

  MostrarPregunta({Key key, @required this.pregunta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool correcto = pregunta.correcto == "1";
    String respuestaCorrecta = (pregunta.respuestaCorrecta == "1")
        ? pregunta.opcionUno
        : pregunta.opcionDos;
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                pregunta.pregunta,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30.0),
              ),
              Text(
                "Respuesta correcta: " + respuestaCorrecta,
                style: TextStyle(fontSize: 18.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
