class SesionAparcamiento {
  final double latitud;
  final double longitud;
  final String direccion;
  final List<String>? fotos; //guardamos rutas de las fotos
  final DateTime fecha;

  SesionAparcamiento({
    required this.latitud,
    required this.longitud,
    required this.direccion,
    required this.fotos,
    required this.fecha,
  });

  //Metodos de serializacion

  Map<String, dynamic> toJson() {
    return {
      'latitud': latitud,
      'longitud': longitud,
      'direccion': direccion,
      'fotos': fotos,
      'fecha': fecha.toIso8601String(), //guardamos la fecha en formato ISO
    };
  }

  //Factroy es un constructor para deserializar
  factory SesionAparcamiento.fromJson(Map<String, dynamic> json) {
    return SesionAparcamiento(
      latitud: json['latitud'],
      longitud: json['longitud'],
      direccion: json['direccion'],
      fotos: json['fotos'] != null ? List<String>.from(json['fotos']) : [],
      fecha: DateTime.parse(json['fecha']),
    );
  }
}
