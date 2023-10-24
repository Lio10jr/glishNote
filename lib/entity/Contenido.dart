import 'package:fastenglish/entity/Datos.dart';

class Contenido {
  final String subtitulo;
  final List<Datos> datos;

  Contenido({
    required this.subtitulo,
    required this.datos,
  });

  factory Contenido.fromJson(Map<String, dynamic> json) {
    final List<dynamic> datosData = json['datos'];
    final List<Datos> datos = datosData.map((item) {
      return Datos.fromJson(item);
    }).toList();

    return Contenido(
      subtitulo: json['subtitulo'],
      datos: datos,
    );
  }
}