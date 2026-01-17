import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:park_snap/modelos/sesion_aparcamiento.dart';
import 'package:park_snap/provider/provider_aparcamiento.dart';
import 'package:park_snap/widgets/mazo_fotos.dart';
import 'package:provider/provider.dart';
import 'package:park_snap/widgets/dialogo_auto_cierre.dart';

//Patallan reutilizable para encontrar el coche o ver el historial de aparcamientos

class PantallaEncontrar extends StatefulWidget {
  final SesionAparcamiento?
  sesion; //Si es null modo busqueda, si es sesion modo historial
  const PantallaEncontrar({super.key, this.sesion});

  @override
  State<PantallaEncontrar> createState() => _PantallaEncontrarState();
}

class _PantallaEncontrarState extends State<PantallaEncontrar> {
  final MapController _mapController = MapController();
  LatLng? _posicionCoche;
  LatLng? _posicionUsuario;
  bool _esModoHistorial = false;
  //La guardamos para poder clancelarla al salir de la pantalla
  StreamSubscription<Position>? _posicionUsuarioSubscription;
  List<String> _fotosSesion = []; // Fotos de la sesion actual

  double?
  _direccionActual; //Guarda la direccion para la flecha del usuario sobre el mapa

  @override
  void initState() {
    super.initState();
    _configurarPantalla();
    //Escucha cambios de la brujula
    FlutterCompass.events?.listen((event) {
      if (mounted) {
        setState(() {
          _direccionActual = event.heading;
        });
      }
    });
  }

  //Cerrar gps al salir para no gastar recursos
  @override
  void dispose() {
    _posicionUsuarioSubscription?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  void _configurarPantalla() {
    //Si es modo historial
    if (widget.sesion != null) {
      _esModoHistorial = true;
      //Capturamos posicion con las coordenadas
      _posicionCoche = LatLng(widget.sesion!.latitud, widget.sesion!.longitud);
      if (widget.sesion!.fotos != null) {
        _fotosSesion = widget.sesion!.fotos!;
      }
      //Si es modo busqueda
    } else {
      _esModoHistorial = false;
      //Preguntamos al provider donde esta el coche
      final provider = Provider.of<ProviderAparcamiento>(
        context,
        listen: false,
      );
      final sesionActual = provider.sesion;

      if (sesionActual != null) {
        _posicionCoche = LatLng(sesionActual.latitud, sesionActual.longitud);
        if (sesionActual.fotos != null) {
          _fotosSesion = sesionActual.fotos!;
        }
        _iniciarSeguimientoUsuario();
      }
    }
  }

  Future<void> _iniciarSeguimientoUsuario() async {
    //Verificamos permisos
    bool serviciosActivados = await Geolocator.isLocationServiceEnabled();
    if (!serviciosActivados) {
      return;
    }

    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        return;
      }
    }

    //Me avisa cada vez que el usuario se mueve
    _posicionUsuarioSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 5, //Notificador cada 5 metros
          ),
        ).listen((posicion) {
          setState(
            () => _posicionUsuario = LatLng(
              posicion.latitude,
              posicion.longitude,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_esModoHistorial ? 'Historial' : 'Encontrar coche'),
        actions: [
          IconButton(
            //Boton para centrar el mapa
            icon: const Icon(Icons.center_focus_strong),
            onPressed: () {
              //Si tenemos usuario centramos ambos puntos, si no centramos en coche
              if (_posicionUsuario != null) {
                _mapController.move(_posicionUsuario!, 15);
              } else {
                _mapController.move(_posicionCoche!, 15);
              }
            },
            tooltip: 'Centrar',
          ),
        ],
      ),
      body: Stack(
        //Pila de capas
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _posicionCoche ?? const LatLng(0, 0),
              initialZoom: 15,
            ),
            children: [
              //Formamos capas, 1 dibuja el mapa
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.parksnap.park_snap',
              ),
              //Capa 2 marca la ruta si es modo encontrar y tenemos usuario
              if (!_esModoHistorial && _posicionUsuario != null)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [_posicionCoche!, _posicionUsuario!],
                      color: Colors.blueAccent.withValues(alpha: 0.7),
                      strokeWidth: 5,
                    ),
                  ],
                ),
              //Capa 3 marcadores
              MarkerLayer(
                markers: [
                  Marker(
                    point: _posicionCoche!,
                    width: 50,
                    height: 50,
                    child: const Icon(
                      Icons.directions_car,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                  if (!_esModoHistorial && _posicionUsuario != null)
                    Marker(
                      point: _posicionUsuario!,
                      width: 50,
                      height: 50,
                      child: Transform.rotate(
                        //Transforma los grados de la brujula a radiantes de flutter para mostrar la flecha como usuario
                        angle: ((_direccionActual ?? 0) * (math.pi / 180) * -1),
                        child: const Icon(
                          Icons.navigation,
                          color: Colors.blue,
                          size: 40,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          // Fotos apiladas si las hay
          if (_fotosSesion.isNotEmpty)
            Positioned(
              bottom: _esModoHistorial
                  ? 30
                  : 110, // Deja espacio para el boton flotante
              left: 0,
              right: 0,
              child: MazoFotos(fotos: _fotosSesion),
            ),
        ],
      ),
      floatingActionButton: _esModoHistorial
          ? null
          : FloatingActionButton.extended(
              backgroundColor: Colors.blueAccent,
              icon: const Icon(Icons.check_circle),
              label: const Text("ENCONTRADO"),
              onPressed: () {
                mostrarDialogoAutoCierre(
                  context: context,
                  texto: "¡Encontrado!",
                  icono: Icons.flag_circle,
                  colorIcono: Colors.blueAccent,
                  onClosed: () {
                    Provider.of<ProviderAparcamiento>(
                      context,
                      listen: false,
                    ).desaparcar();
                    if (context.mounted) Navigator.pop(context);
                  },
                );
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
