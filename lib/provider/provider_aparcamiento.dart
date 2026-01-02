import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../modelos/sesion_aparcamiento.dart';

//ChangeNotifier avisa a las pantallas de los cambios
class ProviderAparcamiento extends ChangeNotifier {
  SesionAparcamiento? _sesion;
  final List<SesionAparcamiento> _sesionesHistorial = [];
  SesionAparcamiento? get sesion => _sesion;
  List<SesionAparcamiento> get sesionesHistorial => _sesionesHistorial;
  bool get estaAparcado => _sesion != null;

  //Clave para guardar en shared preferences
  static const String _keySesion = 'sesion';
  static const String _keyHistorial = 'historial';

  Future<void> cargarDatos() async {
    //Permitimos acceso a shared preferences y buscamos la sesion guardada
    final prefs = await SharedPreferences.getInstance();
    final String? sesionJson = prefs.getString(_keySesion);

    if (sesionJson != null) {
      //Si encuentra usamos el constructor factory
      _sesion = SesionAparcamiento.fromJson(jsonDecode(sesionJson));
    }

    //Cargamos el historial
    final List<String>? historialJson = prefs.getStringList(_keyHistorial);
    if (historialJson != null) {
      _sesionesHistorial.clear(); //Limpiamos la lista y la cargamos de nuevo
      //Si encuentra usamos el constructor factory
      for (var sesionJson in (historialJson)) {
        _sesionesHistorial.add(
          SesionAparcamiento.fromJson(jsonDecode(sesionJson)),
        );
      }
    }
    //Notificamos a la pantalla del cambio
    notifyListeners();
  }

  //Aparcar - Guardar sesion
  Future<void> aparcar(SesionAparcamiento nuevaSesion) async {
    //Creamos la sesion con la informacion actual
    _sesion = nuevaSesion;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySesion, jsonEncode(_sesion!.toJson()));

    //Añadimos al historial
    _sesionesHistorial.insert(
      0,
      nuevaSesion,
    ); //Indice 0 para mostrar el mas reciente

    //Guardamos el historial, recorremos cada item: Sesion - MapaJson - TextoJson
    final List<String> listaSesionesJson = _sesionesHistorial
        .map((s) => jsonEncode(s.toJson()))
        .toList();
    //Guardamos en shared preferences
    await prefs.setStringList(_keyHistorial, listaSesionesJson);
    //Notificamos a la pantalla del cambio
    notifyListeners();
  }

  //Desaparcar - Borrar sesion
  Future<void> desaparcar() async {
    _sesion = null;
    //Accedemos a shared preferences y borramos la sesion guardada
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keySesion);
    //Notificamos a la pantalla del cambio
    notifyListeners();
  }
}
