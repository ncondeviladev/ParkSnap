import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:park_snap/modelos/sesion_aparcamiento.dart';
import 'package:park_snap/provider/provider_aparcamiento.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PantallaMapaHistorial extends StatelessWidget {
  const PantallaMapaHistorial({super.key});

  @override
  Widget build(BuildContext context) {
    //Capturamos historial de aparcamientos
    final historial = Provider.of<ProviderAparcamiento>(
      context,
    ).sesionesHistorial;

    // Calculamos el centro inicial del mapa.
    final centroInicial = historial.isNotEmpty
        ? LatLng(historial.first.latitud, historial.first.longitud)
        : const LatLng(38.96667, -0.18333);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de Aparcamientos"),
        backgroundColor: const Color(0xFF2C3E50),
      ),
      body: FlutterMap(
        options: MapOptions(initialCenter: centroInicial, initialZoom: 13.0),
        children: [
          // Capa de Mapa
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'com.parksnap.park_snap',
          ),

          // Capa de Marcadores
          MarkerLayer(
            markers: historial.map((sesion) {
              return Marker(
                point: LatLng(sesion.latitud, sesion.longitud),
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () {
                    // Al tocar un marcador mostramos info
                    _mostrarDetalleSesion(context, sesion);
                  },
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.orangeAccent,
                    size: 40,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Funcion para mostrar info de las marcas
  void _mostrarDetalleSesion(BuildContext context, SesionAparcamiento sesion) {
    showModalBottomSheet(
      //Panel desde abajo
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('dd/MM/yyyy HH:mm').format(sesion.fecha),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.map, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      sesion.direccion.isNotEmpty
                          ? sesion.direccion
                          : "Ubicación sin dirección",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
