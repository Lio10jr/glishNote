class contenidoPage{
  String? titulo;
  List<String>? subtitulos;

  contenidoPage({required this.titulo, required this.subtitulos});

  contenidoPage.fromJson(Map<String, dynamic> json){
    titulo = json['titulo'];
    subtitulos = List<String>.from(json['subtitulos']);
  }
}