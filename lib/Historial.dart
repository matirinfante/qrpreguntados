// This example shows a [Scaffold] with an [AppBar], a [BottomAppBar] and a
// [FloatingActionButton]. The [body] is a [Text] placed in a [Center] in order
// to center the text within the [Scaffold] and the [FloatingActionButton] is
// centered and docked within the [BottomAppBar] using
// [FloatingActionButtonLocation.centerDocked]. The [FloatingActionButton] is
// connected to a callback that increments a counter.

import 'package:QRPreguntados/PreguntaVisual.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:QRPreguntados/MostrarPregunta.dart';
import 'package:QRPreguntados/Pregunta.dart';
import 'package:QRPreguntados/database/db.dart';
import 'package:QRPreguntados/database/Puntaje.dart';

class Historial extends StatefulWidget {
  @override
  _Historial createState() => _Historial();
}

class _Historial extends State<Historial> {
  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      //TODO: VERIFICAR CORRECTITUD DEL QR
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PreguntaVisual(preg: qrResult)));
    } catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        print("denegado");
      }
    }
  }

  @override
  void didUpdateWidget(Historial oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Desea salir de la aplicacion?"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text("No")),
                FlatButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text("Si"),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('About'),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(
            'QRPreguntados',
          ),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                  child: Text(
                //TODO implementar puntaje persistente
                "Puntaje: " + puntaje.puntos.toString(),
                style: TextStyle(fontSize: 20),
              )),
            ),
            Expanded(
              child: FutureBuilder<List<Pregunta>>(
                future: PreguntaDB.db.getPreguntas(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Pregunta>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          Pregunta item = snapshot.data[index];
                          return ListTile(
                            title: Text(item.pregunta),
                            subtitle: item.correcto == "1"
                                ? Text('Respuesta CORRECTA')
                                : Text('Respuesta INCORRECTA'),
                            leading: item.correcto == "1"
                                ? Icon(Icons.check)
                                : Icon(Icons.close),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MostrarPregunta(
                                        pregunta: item,
                                      )));
                            },
                          );
                        });
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                heroTag: "btnScan",
                onPressed: _scanQR,
                tooltip: 'Agregar una pregunta',
                child: Icon(
                  Icons.add,
                  size: 35,
                ),
                elevation: 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                tooltip: 'Borrar todo',
                child: Icon(
                  Icons.delete_forever,
                  size: 35,
                ),
                heroTag: "btnPrueba",
                onPressed: () async {
                  //TODO dialog para evitar toques accidentales
                  setState(() {});
                  await PreguntaDB.db.resetDB();
                  puntaje.puntos = 0;
                },
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
