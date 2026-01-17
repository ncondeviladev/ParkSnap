import 'package:cloud_firestore/cloud_firestore.dart';

class SesionAparcamiento {
  final String? id;
  final double latitud;
  final double longitud;
  final String direccion;
  final List<String>? fotos;
  final DateTime fecha;
  final bool activa;

  SesionAparcamiento({
    this.id,
    required this.latitud,
    required this.longitud,
    required this.direccion,
    required this.fotos,
    required this.fecha,
    this.activa = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'latitud': latitud,
      'longitud': longitud,
      'direccion': direccion,
      'fotos': fotos,
      'fecha': fecha,
      'activa': activa,
    };
  }

  factory SesionAparcamiento.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return SesionAparcamiento(
      id: doc.id,
      latitud: (data['latitud'] as num).toDouble(),
      longitud: (data['longitud'] as num).toDouble(),
      direccion: data['direccion'] ?? '',
      fotos: data['fotos'] != null ? List<String>.from(data['fotos']) : [],
      fecha: (data['fecha'] as Timestamp).toDate(),
      activa: data['activa'] ?? false,
    );
  }
}
