import 'package:QRPreguntados/Pregunta.dart';
import 'package:QRPreguntados/database/Puntaje.dart';
import 'package:flutter/material.dart';
import 'package:QRPreguntados/database/db.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PreguntaVisual extends StatelessWidget {
  String preg;

  PreguntaVisual({this.preg});

  Widget build(BuildContext context) {
    List<String> csv = preg.split(";");
    Pregunta preguntaAResponder = new Pregunta(
        id: int.parse(csv[0]),
        pregunta: csv[1],
        opcionUno: csv[2],
        opcionDos: csv[3],
        opcionTres: csv[4],
        respuestaCorrecta: csv[5]);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text(
            'Responde la pregunta',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: Container(
            child: Center(
                child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                preguntaAResponder.pregunta,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
              ),
            ),
            Boton(
              p: preguntaAResponder,
            ),
          ],
        ))));
  }
}

class Boton extends StatefulWidget {
  final Pregunta p;

  Boton({this.p});

  @override
  _BotonState createState() => _BotonState();
}

class _BotonState extends State<Boton> {
  var toggleOpcionTres = false,
      toggleOpcionDos = false,
      toggleOpcionUno = false,
      toggleVisible = false,
      respCorrecta = false;

  void _cambiarColor(String numOpcion) {
    setState(() {
      if (widget.p.respuestaCorrecta == numOpcion) {
        _respondeCorrecto(numOpcion);
      } else {
        _respondeIncorrecto(numOpcion);
      }
    });
  }

  void _respondeCorrecto(String numOpcion) {
    setState(() {
      toggleVisible = true;
      respCorrecta = true;
      puntaje.puntos += 1;
      widget.p.correcto = "1";
      switch (numOpcion) {
        case '1':
          toggleOpcionUno = true;
          break;
        case '2':
          toggleOpcionDos = true;
          break;
        case '3':
          toggleOpcionTres = true;
          break;
      }
      //TODO disable buttons.
    });
  }

  void _respondeIncorrecto(String numOpcion) {
    setState(() {
      print("incorrecto");
      toggleVisible = true;
      switch (numOpcion) {
        case '1':
          toggleOpcionUno = true;
          break;
        case '2':
          toggleOpcionDos = true;
          break;
        case '3':
          toggleOpcionTres = true;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: MaterialButton(
            color: !toggleOpcionUno
                ? Colors.cyan[100]
                : (respCorrecta
                    ? Colors.lightGreenAccent[400]
                    : Colors.redAccent[700]),
            child: Text(widget.p.opcionUno),
            onPressed: () => _cambiarColor("1"),
          ),
        ),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width,
        child: MaterialButton(
          color: (!toggleOpcionDos
              ? Colors.cyan[100]
              : (respCorrecta
                  ? Colors.lightGreenAccent[400]
                  : Colors.redAccent[700])),
          child: Text(widget.p.opcionDos),
          onPressed: () => _cambiarColor("2"),
        ),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width,
        child: MaterialButton(
          color: (!toggleOpcionTres
              ? Colors.cyan[100]
              : (respCorrecta
                  ? Colors.lightGreenAccent[400]
                  : Colors.redAccent[700])),
          child: Text(widget.p.opcionTres),
          onPressed: () => _cambiarColor("3"),
        ),
      ),
      Visibility(
          visible: toggleVisible,
          child: RaisedButton(
            onPressed: () async {
              await PreguntaDB.db.addPregunta(widget.p);
              Navigator.pop(context);
            },
            child: Text(
              "SIGUIENTE",
              textAlign: TextAlign.center,
            ),
          ))
    ]);
  }
}
