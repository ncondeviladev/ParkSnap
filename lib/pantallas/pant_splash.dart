import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  Future<void> _iniciarApp() async {
    // Carga de datos
    await Provider.of<ProviderAparcamiento>(
      context,
      listen: false,
    ).cargarDatos();

    // Pequeña espera para disfrutar la animacion
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder:
              (_, __, ___) => // "__" son atributos vacios que no necesitoamos
                  const PantallaInicio(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
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
