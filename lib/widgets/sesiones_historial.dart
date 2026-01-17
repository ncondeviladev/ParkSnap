import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ... (existing imports, but I'll target the import block first)

import 'package:park_snap/modelos/sesion_aparcamiento.dart';
import 'package:park_snap/pantallas/pant_encontrar.dart';

class SesionesHistorial extends StatelessWidget {
  final List<SesionAparcamiento> sesiones;
  const SesionesHistorial({super.key, required this.sesiones});

  @override
  Widget build(BuildContext context) {
    //Si la lista está vaccia mostramos un mensaje simple
    if (sesiones.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.history, size: 40, color: Colors.grey),
              SizedBox(height: 10),
              Text(
                "No hay sesiones guardadas",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
    //Si hay datos devolvemos la lista construida
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Titulo de la seccion
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            "Aparcamientos recientes",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
        ),

        // Quitamos el expanded y usamos shrinkWrap en la lista para que funcione en scroll
        ListView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(), // El scroll lo maneja el builder
          itemCount: sesiones.length,
          itemBuilder: (context, index) {
            //Funcion que dibuja cada fila
            final sesion =
                sesiones[index]; //Obtenemos cada sesion del historial usando el indice

            return Card(
              margin: const EdgeInsets.symmetric(
                //Separacion entre cards
                horizontal: 16.0,
                vertical: 4.0,
              ),
              color: Colors.white10,

              child: ListTile(
                //LIistTile formato estandar para filas (icono, titulo, subtitulo y fecha) actua como bucle mostrando cada tarjeta
                leading: const Icon(
                  //leading primera posicion de listtile
                  Icons.history,
                  color: Colors.blueAccent,
                ),
                //Titulo direccion
                title: Text(
                  sesion.direccion,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                //Subtitulo fecha
                subtitle: Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(sesion.fecha),
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white70,
                ),
                onTap: () {
                  //Navegamos a la pantalla de encontrar coche
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PantallaEncontrar(sesion: sesion),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
