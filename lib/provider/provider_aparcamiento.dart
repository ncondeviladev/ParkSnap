import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../modelos/sesion_aparcamiento.dart';
import '../data/sesion_repository.dart';

class ProviderAparcamiento extends ChangeNotifier {
  SesionAparcamiento? _sesion;
  List<SesionAparcamiento> _sesionesHistorial = [];

  SesionAparcamiento? get sesion => _sesion;
  List<SesionAparcamiento> get sesionesHistorial => _sesionesHistorial;
  bool get estaAparcado => _sesion != null;

  bool _escuchando = false;

  Future<void> cargarDatos() async {
    if (_escuchando) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _escuchando = true;
      // Escuchamos los cambios en la nube
      SesionRepository.getSesiones(user.uid).listen((lista) {
        _sesionesHistorial = lista;
        try {
          // Buscamos si hay alguna sesion marcada como activa
          _sesion = _sesionesHistorial.firstWhere((s) => s.activa == true);
        } catch (e) {
          _sesion = null;
        }
        notifyListeners();
      });
    }
  }

  Future<void> aparcar(SesionAparcamiento sesion) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final sesionActiva = SesionAparcamiento(
      latitud: sesion.latitud,
      longitud: sesion.longitud,
      direccion: sesion.direccion,
      fotos: sesion.fotos,
      fecha: sesion.fecha,
      activa: true, // Se guarda como activa en Firestore
    );

    // Guardamos en la nube
    await SesionRepository.addSesion(user.uid, sesionActiva);
  }

  Future<void> desaparcar() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _sesion != null) {
      final sesionFinalizada = SesionAparcamiento(
        id: _sesion!.id,
        latitud: _sesion!.latitud,
        longitud: _sesion!.longitud,
        direccion: _sesion!.direccion,
        fotos: _sesion!.fotos,
        fecha: _sesion!.fecha,
        activa: false,
      );

      await SesionRepository.updateSesion(user.uid, sesionFinalizada);
      _sesion = null;
      notifyListeners();
    }
  }
}
