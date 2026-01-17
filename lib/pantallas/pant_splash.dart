import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:park_snap/pantallas/pant_auth.dart';
import 'package:park_snap/pantallas/pant_inicio.dart';
import 'package:park_snap/provider/provider_aparcamiento.dart';
import 'package:provider/provider.dart';

class PantallaSplash extends StatefulWidget {
  const PantallaSplash({super.key});

  @override
  State<PantallaSplash> createState() => _PantallaSplashState();
}

class _PantallaSplashState extends State<PantallaSplash> {
  @override
  void initState() {
    super.initState();
    _iniciarApp();
  }

  //Ahora pantalla splash comprueba login
  Future<void> _iniciarApp() async {
    // Carga inicial
    await Provider.of<ProviderAparcamiento>(
      context,
      listen: false,
    ).cargarDatos();
    // Espera de la animacion
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    // Ecuentra usuario logeado?
    final user = FirebaseAuth.instance.currentUser;

    Widget pantallaSiguiente;
    if (user != null) {
      // Si hay  vamos a la pantalla principal
      pantallaSiguiente = const PantallaInicio();
    } else {
      // Si no vamos al login
      pantallaSiguiente = const PantallaAuth();
    }
    // Navegación final
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => pantallaSiguiente),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2C3E50), // Azul oscuro elegante
              Color(0xFF000000), // Negro
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo con efecto de respiracion/brillo
              AvatarGlow(
                glowColor: Colors.blueAccent,
                duration: const Duration(milliseconds: 2000),
                repeat: true,
                startDelay: const Duration(seconds: 0),
                child: Image.asset(
                  "assets/images/logoParkSnap.png",
                  height: 200,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              const SizedBox(height: 10),
              Text(
                "Tu coche, siempre localizado",
                style: GoogleFonts.lato(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
