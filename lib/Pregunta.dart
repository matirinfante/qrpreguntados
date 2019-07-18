class Pregunta {
  String respuestaCorrecta,
      correcto,
      pregunta,
      opcionUno,
      opcionDos,
      opcionTres;
  int id;

  Pregunta(
      {this.id,
      this.pregunta,
      this.opcionUno,
      this.opcionDos,
      this.opcionTres,
      this.respuestaCorrecta,
      this.correcto});

  Map<String, dynamic> toMap() => {
        "id": id,
        "pregunta": pregunta,
        "opcionUno": opcionUno,
        "opcionDos": opcionDos,
        "opcionTres": opcionTres,
        "respuesta": respuestaCorrecta,
        "correcto": correcto,
      };

  factory Pregunta.fromMap(Map<String, dynamic> json) => new Pregunta(
        id: json["id"],
        pregunta: json["pregunta"],
        opcionUno: json["opcionUno"],
        opcionDos: json["opcionDos"],
        opcionTres: json["opcionTres"],
        respuestaCorrecta: json["respuesta"],
        correcto: json["correcto"],
      );
}
