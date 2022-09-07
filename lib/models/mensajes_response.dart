// To parse this JSON data, do
//
//     final mensajesResponse = mensajesResponseFromJson(jsonString);

import 'dart:convert';

MensajesResponse mensajesResponseFromJson(String str) =>
    MensajesResponse.fromJson(json.decode(str));

String mensajesResponseToJson(MensajesResponse data) =>
    json.encode(data.toJson());

class MensajesResponse {
  MensajesResponse({
    required this.ok,
    required this.mensaje,
    required this.miId,
    required this.mensajedDe,
  });

  bool ok;
  List<Mensaje> mensaje;
  String miId;
  String mensajedDe;

  factory MensajesResponse.fromJson(Map<String, dynamic> json) =>
      MensajesResponse(
        ok: json["ok"],
        mensaje:
            List<Mensaje>.from(json["mensaje"].map((x) => Mensaje.fromJson(x))),
        miId: json["miId"],
        mensajedDe: json["mensajedDe"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "mensaje": List<dynamic>.from(mensaje.map((x) => x.toJson())),
        "miId": miId,
        "mensajedDe": mensajedDe,
      };
}

class Mensaje {
  Mensaje({
    required this.de,
    required this.para,
    required this.mensaje,
    required this.createdAt,
    required this.updatedAt,
  });

  String de;
  String para;
  String mensaje;
  DateTime createdAt;
  DateTime updatedAt;

  factory Mensaje.fromJson(Map<String, dynamic> json) => Mensaje(
        de: json["de"],
        para: json["para"],
        mensaje: json["mensaje"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "de": de,
        "para": para,
        "mensaje": mensaje,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
