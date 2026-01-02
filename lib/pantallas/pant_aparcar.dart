import 'dart:io';
import 'dart:math';
import 'package:park_snap/pantallas/pant_camara.dart';

// ... (existing imports, but since I'm targeting the whole file structure or large chunk, I'll be careful)
// Actually I will use replace_file_content targeted chunks.
// First chunk: Imports and State
// Second chunk: Build method changes

import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:park_snap/modelos/sesion_aparcamiento.dart';
import 'package:park_snap/provider/provider_aparcamiento.dart';
import 'package:park_snap/widgets/mazo_fotos.dart';
import 'package:provider/provider.dart';
import 'package:park_snap/widgets/dialogo_auto_cierre.dart';

class PantallaAparcar extends StatefulWidget {
  const PantallaAparcar({super.key});

  @override
  State<PantallaAparcar> createState() => _PantallaAparcarState();
}

class _PantallaAparcarState extends State<PantallaAparcar> {
  final MapController mapController = MapController();
  LatLng? _ubicacionActual;
  bool _cargando = true; //Controla si se muestra icono cargando o mapa
  final List<String> _fotos = [];

  Future<void> _tomarFoto() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PantallaCamara()),
    );

    if (resultado != null && resultado is String) {
      setState(() {
        _fotos.add(resultado);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //Nada mas inicia la pantalla pedimos la ubicacion actual
    _obtenerUbicacion();
  }

  //Funcion asincrona porque gps tarda un poco
  Future<void> _obtenerUbicacion() async {
    bool servicioActivado;
    LocationPermission permiso;

    servicioActivado = await Geolocator.isLocationServiceEnabled();
    if (!servicioActivado) {
      return; //Si no hay gps activado no hacemos nada
    }

    //Pedimos permiso al usuario para acceder a su ubicacion
    permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        _mostrarError("Error al obtener la ubicacion");
        return;
      }
    }
    //Si todo esta ok, pedimos la ubicacion actual
    try {
      //Maxima precision
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      //Si el widget sigue montado (no se ha desmontado)
      if (mounted) {
        setState(() {
          //Actualiza la pantalla
          _ubicacionActual = LatLng(
            pos.latitude,
            pos.longitude,
          ); //Position - LatLng
          _cargando = false; //Quitamos icono cargando
        });
      }
    } catch (e) {
      _mostrarError("Error al obtener la ubicacion $e");
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  //INTERFAZ GRAFICA
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Confirmar Ubicación")),

      floatingActionButton: _ubicacionActual == null
          ? null //Si no hay ubicacion actual no mostramos boton
          : Column(
              //Fotos apiladas
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Lista de fotos (Mazo Interactivo)
                if (_fotos.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: MazoFotos(fotos: _fotos),
                  ),

                Row(
                  //Botones inferiores
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      heroTag: "btnCamara",
                      onPressed: _tomarFoto,
                      backgroundColor: Colors.blueAccent,
                      child: const Icon(Icons.camera_alt),
                    ),
                    const SizedBox(width: 16),
                    FloatingActionButton.extended(
                      heroTag: "btnAparcar",
                      icon: const Icon(Icons.check),
                      label: const Text("APARCAR AQUÍ"),
                      backgroundColor: Colors.green,
                      onPressed: () async {
                        String direccion = "Ubicación desconocida";
                        try {
                          List<Placemark> placemarks =
                              await placemarkFromCoordinates(
                                _ubicacionActual!.latitude,
                                _ubicacionActual!.longitude,
                              );
                          if (placemarks.isNotEmpty) {
                            final p = placemarks.first;
                            direccion =
                                "${p.street}, ${p.subThoroughfare ?? ''}"
                                    .trim();
                            if (direccion == ",") {
                              direccion = "Ubicación sin nombre";
                            }
                          }
                        } catch (e) {
                          print("Error obteniendo dirección: $e");
                        }

                        //Si el widget sigue montado
                        if (!context.mounted) return;

                        // RUIDO ALEATORIO (SOLO DEBUG)
                        final random = Random();
                        final offsetLat = (random.nextDouble() - 0.5) * 0.005;
                        final offsetLng = (random.nextDouble() - 0.5) * 0.005;

                        final nuevaSesion = SesionAparcamiento(
                          fecha: DateTime.now(),
                          latitud:
                              _ubicacionActual!.latitude + offsetLat, // Offset
                          longitud:
                              _ubicacionActual!.longitude + offsetLng, // Offset
                          direccion: direccion,
                          fotos: List.from(_fotos),
                        );
                        //Guardamos la sesion en el provider
                        Provider.of<ProviderAparcamiento>(
                          context,
                          listen: false,
                        ).aparcar(nuevaSesion);
                        //Mostramos dialogo de éxito

                        mostrarDialogoAutoCierre(
                          context: context,
                          texto: "¡Aparcado!",
                          icono: Icons.check_circle,
                          colorIcono: Colors.green,
                          onClosed: () {
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _ubicacionActual == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 40, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text("No se ha podido obtener la ubicación"),
                  ElevatedButton(
                    onPressed: _obtenerUbicacion,
                    child: const Text("Volver a intentar"),
                  ),
                ],
              ),
            )
          //Si todo esta bien mostramos el mapa
          : FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter:
                    _ubicacionActual!, //Muestra mapa centrado en el coche
                initialZoom: 15,
              ),
              children: [
                TileLayer(
                  //Dibuja mapa de OpenStreetMap
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: 'com.parksnap.park_snap',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _ubicacionActual!,
                      width: 80,
                      height: 80,
                      child: const Icon(
                        Icons.location_pin,
                        size: 40,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
