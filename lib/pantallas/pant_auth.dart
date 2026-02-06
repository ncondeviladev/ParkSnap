import 'package:app_settings/app_settings.dart'; // Import para abrir settings
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:park_snap/pantallas/pant_inicio.dart';
import 'package:provider/provider.dart';
import 'package:park_snap/provider/provider_aparcamiento.dart';

class PantallaAuth extends StatelessWidget {
  const PantallaAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //Añadido appbar en pantalla autenticacion para poder poner el boton atras
        title: const Text("ParkSnap"),
        centerTitle: true,
      ),
      body: SignInScreen(
        providers: [
          EmailAuthProvider(),
          GoogleProvider(clientId: ''),
        ],
        actions: [
          AuthStateChangeAction<SignedIn>((context, state) {
            // Recargamos datos del nuevo usuario logueado
            Provider.of<ProviderAparcamiento>(
              context,
              listen: false,
            ).cargarDatos();

            //Si el login es correcto salta a incio
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PantallaInicio()),
            );
          }),
        ],
      ),
      //Añadido boton de alerta falta de red en pantalla de autenticacion
      floatingActionButton: StreamBuilder<List<ConnectivityResult>>(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot) {
          // Si no hay datos aun, no asumimos error.
          if (!snapshot.hasData) return const SizedBox.shrink();

          final resultados = snapshot.data!;
          bool tieneRed = resultados.any(
            (red) => red != ConnectivityResult.none,
          );

          if (tieneRed) return const SizedBox.shrink();

          return FloatingActionButton.extended(
            onPressed: () =>
                AppSettings.openAppSettings(type: AppSettingsType.dataRoaming),
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
  }
}
