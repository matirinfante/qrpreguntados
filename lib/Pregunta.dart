class Pregunta {
  String respuestaCorrecta, pregunta;
  int id, respondioCorrecto;

  Pregunta(
      {this.id, this.pregunta, this.respuestaCorrecta, this.respondioCorrecto});

  void setRespondioCorrecto(int nuevo) {
    this.respondioCorrecto = nuevo;
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "pregunta": pregunta,
        "respuestaCorrecta": respuestaCorrecta,
        "respondioCorrecto": respondioCorrecto,
      };

  factory Pregunta.fromMap(Map<String, dynamic> json) => new Pregunta(
        id: json["id"],
        pregunta: json["pregunta"],
        respuestaCorrecta: json["respuestaCorrecta"],
        respondioCorrecto: json["respondioCorrecto"],
      );
}
