import 'package:DesafioxBardas/PreguntaVisual.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:DesafioxBardas/MostrarPregunta.dart';
import 'package:DesafioxBardas/Pregunta.dart';
import 'package:DesafioxBardas/database/db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Historial extends StatefulWidget {
  @override
  _Historial createState() => _Historial();
}

class _Historial extends State<Historial> {
  int _puntaje;

  initState() {
    super.initState();
    _obtenerPuntaje().then((result) {
      setState(() {
        _puntaje = result;
      });
    });
  }

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      List<String> check = qrResult.split(';');
      if (check.length < 2) {
        print('jaja');
      } else if (check.length >= 3) {
        var options = check[2];
        if (isNumeric(options) &&
            (check.length < int.parse(options) + 4 ||
                check.length > int.parse(options) + 4)) {
          print('Jaja');
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PreguntaVisual(preg: qrResult)));
        }
      } else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PreguntaVisual(preg: qrResult)));
      }
    } catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        print("denegado");
      }
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  Future<int> _obtenerPuntaje() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'puntaje';
    final resultado = prefs.getInt(key) ?? 0;
    return resultado;
  }

  _resetPuntaje() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'puntaje';
    prefs.setInt(key, 0);
    setState(() {
      _puntaje = prefs.getInt(key);
    });
  }

  @override
  void didUpdateWidget(Historial oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  Future<bool> _onBackPressed() {
    return Alert(
      context: context,
      type: AlertType.info,
      title: "SALIR",
      desc: "¿Desea salir de la aplicación?",
      buttons: [
        DialogButton(
          child: Text(
            "CANCELAR",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context, false),
          color: Colors.red,
        ),
        DialogButton(
          child: Text(
            "ACEPTAR",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context, true),
          color: Colors.lightGreen,
        )
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: GlobalKey(),
        drawer: Drawer(
          //MENU
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('About'),
                  onTap: () {
                    Navigator.of(context).pop();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Scaffold(
                            appBar: AppBar(
                              title: Text('Acerca...'),
                            ),
                            body: Center(
                                child: Container(
                                    child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(children: <Widget>[
                                Text(
                                  'Sponsor',
                                  style: TextStyle(
                                      fontSize: 20, fontFamily: 'Ubuntu'),
                                ),
                                Flexible(
                                    flex: 5,
                                    child: Container(
                                        height: 100,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/logos/img1.png'))))),
                                Text(
                                  'Colaboradores Oro',
                                  style: TextStyle(
                                      fontSize: 20, fontFamily: 'Ubuntu'),
                                ),
                                Flexible(
                                    flex: 5,
                                    child: CarouselSlider(
                                      viewportFraction: 1.0,
                                      autoPlay: true,
                                      items: [2, 3, 4, 5].map((i) {
                                        return Builder(
                                          builder: (BuildContext context) {
                                            return Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/logos/img$i.png'),
                                                  fit: BoxFit.scaleDown,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }).toList(),
                                    )),
                                Text(
                                  'Colaboradores Plata',
                                  style: TextStyle(
                                      fontSize: 20, fontFamily: 'Ubuntu'),
                                ),
                                Flexible(
                                    flex: 5,
                                    child: CarouselSlider(
                                      viewportFraction: 1.0,
                                      autoPlay: true,
                                      items: [6, 7].map((i) {
                                        return Builder(
                                          builder: (BuildContext context) {
                                            return Container(
                                              height: 150,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/logos/img$i.png'),
                                                  fit: BoxFit.scaleDown,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }).toList(),
                                    )),
                                Text(
                                  'Organizadores',
                                  style: TextStyle(
                                      fontSize: 20, fontFamily: 'Ubuntu'),
                                ),
                                Flexible(
                                    flex: 5,
                                    child: CarouselSlider(
                                      viewportFraction: 1.0,
                                      autoPlay: true,
                                      items: [8, 9, 10].map((i) {
                                        return Builder(
                                          builder: (BuildContext context) {
                                            return Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/logos/img$i.png'),
                                                  fit: BoxFit.scaleDown,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }).toList(),
                                    ))
                              ]),
                            ))),
                          );
                        });
                  },
                ),
              ),
              /*Padding(
                padding: EdgeInsets.only(top: 10),
                child: ListTile(
                    leading: Icon(Icons.delete_forever),
                    title: Text('Borrar todo'),
                    onTap: () async {
                      setState(() {});
                      await PreguntaDB.db.resetDB();
                      await _resetPuntaje();
                      Navigator.pop(context);
                    }),
              ),*/
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text(
            'Desafio por las Bardas 2019',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                  child: Text('Puntaje: $_puntaje',
                      style: TextStyle(
                        fontSize: 40,
                        fontFamily: 'Raleway',
                      ))),
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
                            title: Text(
                              item.pregunta,
                              style: TextStyle(fontFamily: 'Roboto'),
                            ),
                            subtitle: item.respondioCorrecto == 1
                                ? Text(
                                    'Respuesta CORRECTA',
                                    style: TextStyle(fontFamily: 'Raleway'),
                                  )
                                : Text('Respuesta INCORRECTA',
                                    style: TextStyle(fontFamily: 'Raleway')),
                            leading: item.respondioCorrecto == 1
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
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FloatingActionButton.extended(
                heroTag: "btnScan",
                backgroundColor: Colors.orange,
                onPressed: _scanQR,
                tooltip: 'Agregar una pregunta',
                icon: Icon(
                  Icons.add,
                  size: 35,
                ),
                label: Text(
                  'AGREGAR\nPREGUNTA',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                elevation: 2,
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
