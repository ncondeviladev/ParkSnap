import 'dart:async';
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

//Cambiamos el bool por un subscription para escuchar los cambios en tiempo real
  StreamSubscription? _subscription;

  Future<void> cargarDatos() async {
    // Si ya estamos escuchando al usuario actual, no hacemos nada pero si cambia de usuario reiniciamos
    final user = FirebaseAuth.instance.currentUser;

    // Si no hay usuario limpiamos y salimos
    if (user == null) {
      limpiarDatos();
      return;
    }

    // Cancelamos suscripcion anterior si existe 
    await _subscription?.cancel();

   
    _subscription = SesionRepository.getSesiones(user.uid).listen((lista) {
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

  void limpiarDatos() {
    _subscription?.cancel();
    _subscription = null;
    _sesionesHistorial = [];
    _sesion = null;
    notifyListeners();
  }

  Future<void> aparcar(SesionAparcamiento sesion) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final sesionActiva = SesionAparcamiento(
      latitud: sesion.latitud,
      longitud: sesion.longitud,
      direccion: sesion.direccion,
      fotos: sesion.fotos, // Se guarda la ruta local
      fecha: sesion.fecha,
      activa: true,
    );

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
