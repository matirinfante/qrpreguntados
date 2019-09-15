import 'package:DesafioxBardas/Pregunta.dart';
import 'package:DesafioxBardas/Historial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:DesafioxBardas/database/db.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ContenedorTemporal {
  int id, cantOpciones, indexCorrecto;
  String pregunta;
  List<String> opciones;

  ContenedorTemporal(
      {this.id,
      this.pregunta,
      this.cantOpciones,
      this.opciones,
      this.indexCorrecto});
}

class PreguntaVisual extends StatelessWidget {
  String preg;

  PreguntaVisual({this.preg});

  ContenedorTemporal _inputFormat(String input) {
    List<String> csv = preg.split(";"), opciones = new List<String>();
    int cantOpciones = int.parse(csv[2]);
    opciones = csv.sublist(3, 3 + cantOpciones);
    ContenedorTemporal preguntaAResponder = new ContenedorTemporal(
        id: int.parse(csv[0]),
        pregunta: csv[1],
        cantOpciones: cantOpciones,
        opciones: opciones,
        indexCorrecto: int.parse(csv[csv.length - 1]));
    return preguntaAResponder;
  }

  Widget build(BuildContext context) {
    ContenedorTemporal preguntaAResponder = _inputFormat(preg);

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
            color: Colors.orange[100],
            child: Center(
                child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      top: 12.0, bottom: 12.0, left: 5.0, right: 5.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          preguntaAResponder.pregunta,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'LexendDeca',
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Boton(
                  data: preguntaAResponder,
                ),
              ],
            ))));
  }
}

class Boton extends StatefulWidget {
  final ContenedorTemporal data;

  Boton({this.data});

  @override
  _BotonState createState() => _BotonState();
}

class _BotonState extends State<Boton> {
  var respCorrecta = false;
  Pregunta aGuardar;

  @override
  void initState() {
    aGuardar = new Pregunta(
        id: widget.data.id,
        pregunta: widget.data.pregunta,
        respuestaCorrecta: widget.data.opciones[widget.data.indexCorrecto - 1],
        respondioCorrecto: 0);
  }

  void _verificarRespuesta(int numOpcion) {
    setState(() {
      if (widget.data.indexCorrecto - 1 == numOpcion) {
        respCorrecta = true;
        aGuardar.setRespondioCorrecto(1);
      }
    });
  }

  _agregarPregunta() async {
    if (await PreguntaDB.db.addPregunta(aGuardar) == aGuardar.id &&
        respCorrecta) {
      print('PASA POR AGREGAR PREGUNTA');
      _incrementarPuntaje();
    }
  }

  _incrementarPuntaje() async {
    final prefs = await SharedPreferences.getInstance();
    int puntajeAnterior = prefs.getInt('puntaje') ?? 0;
    int puntajeActual = ++puntajeAnterior;
    prefs.setInt('puntaje', puntajeActual);
    print('ACTUALIZA A : $puntajeActual');
  }

  _animacionRespuesta(context) {
    Alert(
      context: context,
      style: AlertStyle(
          isCloseButton: false,
          isOverlayTapDismiss: false,
          animationType: AnimationType.grow),
      type: respCorrecta ? AlertType.success : AlertType.error,
      title: respCorrecta ? 'CORRECTO!' : 'INCORRECTO',
      desc: respCorrecta ? 'Sumas un punto' : 'Segui intentandolo',
      buttons: [
        DialogButton(
          child: Text(
            "VOLVER",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            await _agregarPregunta();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Historial()),
                (Route<dynamic> route) => false);
          },
          width: 120,
        )
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: widget.data.cantOpciones,
        itemBuilder: (BuildContext context, int index) {
          String opcion = widget.data.opciones[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: SizedBox(
              key: Key('$index'),
              width: MediaQuery.of(context).size.width,
              child: MaterialButton(
                  height: MediaQuery.of(context).size.height / 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    opcion,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w300),
                  ),
                  color: Colors.white,
                  onPressed: () {
                    _verificarRespuesta(index);
                    _animacionRespuesta(context);
                  }),
            ),
          );
        });

    /*return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: MaterialButton(
            color: Colors.cyan[100],
            child: Text(widget.p.opcionUno),
            onPressed: () {
              _verificarRespuesta('1');
              _animacionRespuesta(context);
            },
          ),
        ),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width,
        child: MaterialButton(
          color: Colors.cyan[100],
          child: Text(widget.p.opcionDos),
          onPressed: () {
            _verificarRespuesta('2');
            _animacionRespuesta(context);
          },
        ),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width,
        child: MaterialButton(
          color: Colors.cyan[100],
          child: Text(widget.p.opcionTres),
          onPressed: () {
            _verificarRespuesta('3');
            _animacionRespuesta(context);
          },
        ),
      ),
    ]);*/
  }
}
