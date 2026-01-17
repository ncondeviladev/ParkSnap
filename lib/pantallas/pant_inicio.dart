import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:park_snap/pantallas/pant_aparcar.dart';
import 'package:park_snap/pantallas/pant_auth.dart';
import 'package:park_snap/pantallas/pant_encontrar.dart';
import 'package:park_snap/widgets/dialogo_auto_cierre.dart';
import 'package:park_snap/provider/provider_aparcamiento.dart';
import 'package:park_snap/widgets/boton_accion.dart';
import 'package:park_snap/widgets/sesiones_historial.dart';
import 'package:provider/provider.dart';
import 'package:park_snap/pantallas/pant_mapa_historial.dart';
import 'package:app_settings/app_settings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    //Consumer escucha cambios en el provider
    return Consumer<ProviderAparcamiento>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF2C3E50),
            elevation: 10,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
            ),
            centerTitle: false,
            title: Row(
              children: [
                Image.asset(
                  "assets/images/logoParkSnap.png",
                  height: 45,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                Text(
                  "ParkSnap",
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                //Boton historial
                icon: const Icon(Icons.map_outlined, color: Colors.white),
                tooltip: "Mapa Historial",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PantallaMapaHistorial(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              IconButton(
                //boton logout
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                tooltip: "Cerrar Sesión",
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PantallaAuth(),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //Zona central con botón eliminamos container por el scroll
                  Center(
                    child: provider.estaAparcado
                        //SI ESTA APARCADO MOSTRAMOS BOTON DESAPARCAR
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20),
                              BotonAccion(
                                icono: MdiIcons.mapSearch,
                                texto: "ENCONTRAR",
                                color: const Color(0xFF2ECC71),
                                accion: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PantallaEncontrar(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 40),

                              ElevatedButton(
                                onPressed: () {
                                  mostrarDialogoAutoCierre(
                                    context: context,
                                    texto: "¡Encontrado!",
                                    icono: Icons.flag_circle,
                                    colorIcono: Colors.blueAccent,
                                    onClosed: () => provider.desaparcar(),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white.withOpacity(
                                    0.1,
                                  ), // Fondo sutil
                                  foregroundColor:
                                      Colors.greenAccent, // Texto verde
                                  side: const BorderSide(
                                    color: Colors.greenAccent,
                                  ), // Borde verde
                                  shape:
                                      const StadiumBorder(), // Bordes muy redondos
                                ),
                                child: const Text("¡Encontrado!"),
                              ),
                              const SizedBox(height: 20),
                            ],
                          )
                        //SI NO ESTA APARCADO MOSTRAMOS BOTON APARCAR
                        : Padding(
                            //Envolvemos con padding para separar del historial
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: BotonAccion(
                              icono: MdiIcons.carSports,
                              texto: "APARCAR",
                              color: const Color(0xFF3498DB),
                              accion: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PantallaAparcar(),
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                  const Divider(height: 40, color: Colors.grey),
                  //Zona inferior con historial
                  SesionesHistorial(sesiones: provider.sesionesHistorial),
                ],
              ),
            ),
          ),
          //Boton inteligente de red
          floatingActionButton: StreamBuilder<List<ConnectivityResult>>(
            stream: Connectivity().onConnectivityChanged,
            builder: (context, snapshot) {
              final resultados = snapshot.data ?? [];
              bool tieneRed = resultados.any(
                (red) => red != ConnectivityResult.none,
              );

              if (tieneRed) return const SizedBox.shrink();

              return FloatingActionButton.extended(
                onPressed: () => AppSettings.openAppSettings(
                  type: AppSettingsType.dataRoaming,
                ),
                backgroundColor: Colors.red,
                icon: const Icon(Icons.wifi_off, color: Colors.white),
                label: const Text(
                  "SIN RED - ACTIVAR DATOS",
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
