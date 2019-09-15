import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:DesafioxBardas/Historial.dart';

class Index extends StatefulWidget {
  @override
  _Index createState() => _Index();
}

class _Index extends State<Index> {
  bool errorQR = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      if (qrResult == 'carreradesafioporlasbardas2019') {
        await _updateInicio();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Historial()),
            (Route<dynamic> route) => false);
      } else {
        setState(() {
          errorQR = true;
        });
      }
    } catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        print("denegado");
      }
    }
  }

  void _updateInicio() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'inicioCarrera';
    prefs.setBool(key, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
            //Se decora to-do el contenedor
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.lightGreen,
              image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.1), BlendMode.dstATop),
                image: AssetImage('assets/img/img1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            //Se agrupan los siguientes widgets en una columna.
            child: Stack(children: <Widget>[
              IgnorePointer(
                  child: CarouselSlider(
                viewportFraction: 1.0,
                height: MediaQuery.of(context).size.height,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 5),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                items: [1, 2].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          image: DecorationImage(
                            colorFilter: new ColorFilter.mode(
                                Colors.black.withOpacity(0.7),
                                BlendMode.dstATop),
                            image: AssetImage('assets/img/img$i.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              )),
              Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: SizedBox(
                        height: 200,
                        width: 200,
                        child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/logodxb.png')))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 26.0, right: 35.0, left: 35.0),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            'ESCANEA EL CÓDIGO QR ANTES DE INICIAR LA CARRERA',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(
                          left: 30.0, right: 30.0, top: 20.0),
                      alignment: Alignment.center,
                      child: new Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 20.0),
                        alignment: Alignment.center,
                        child: new Row(
                          children: <Widget>[
                            new Expanded(
                              child: new FlatButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                                color: Colors.orange,
                                onPressed: () {
                                  _scanQR();
                                  if (errorQR) {
                                    final sb = SnackBar(
                                      content: Row(
                                        children: <Widget>[
                                          Icon(Icons.warning),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              'Codigo Incorrecto.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Roboto',
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ],
                                      ),
                                      duration: Duration(seconds: 4),
                                      backgroundColor: Colors.red,
                                    );
                                    _scaffoldKey.currentState.showSnackBar(sb);
                                    setState(() {
                                      errorQR = false;
                                    });
                                  }
                                },
                                child: new Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20.0,
                                    horizontal: 20.0,
                                  ),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Expanded(
                                        child: Text(
                                          "INICIAR",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Roboto',
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ])));
  }
}
