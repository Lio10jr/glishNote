class Datos {
  final String uso;
  final String informacion;
  final List<String> ejemplos;

  Datos({
    required this.uso,
    required this.informacion,
    required this.ejemplos,
  });

  factory Datos.fromJson(Map<String, dynamic> json) {
    final List<dynamic> ejemplosData = json['Ejemplos'];
    final List<String> ejemplos = ejemplosData.map((item) {
      return item as String;
    }).toList();

    return Datos(
      uso: json['uso'],
      informacion: json['informacion'],
      ejemplos: ejemplos,
    );
  }
}