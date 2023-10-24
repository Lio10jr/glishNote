import 'package:fastenglish/entity/Contenido.dart';

class ContenidoPageTitulo {
  String titulo;
  String utilizacion;
  List<Contenido> contenido;

  ContenidoPageTitulo({
    required this.titulo,
    required this.utilizacion,
    required this.contenido,
  }); 

  factory ContenidoPageTitulo.fromJson(Map<String, dynamic> json) {
    List<dynamic> contenidoData = json['contenido'];

    List<Contenido> contenido = contenidoData.map((item) {
      return Contenido.fromJson(item);
    }).toList();

    return ContenidoPageTitulo(
      titulo: json['titulo'] ?? '',
      utilizacion: json['Utilización'] ?? '',
      contenido: contenido,
    );
  }
}