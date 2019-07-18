class Puntaje {
  static final Puntaje _puntaje = new Puntaje._internal();
  int puntos = 0;
  factory Puntaje() {
    return _puntaje;
  }

  Puntaje._internal();
}

final puntaje = Puntaje();
