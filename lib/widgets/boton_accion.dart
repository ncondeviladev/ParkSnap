import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class BotonAccion extends StatelessWidget {
  final IconData icono;
  final String texto;
  final Color color;
  final VoidCallback accion;
  final double tamanyo;

  const BotonAccion({
    super.key,
    required this.icono,
    required this.texto,
    required this.color,
    required this.accion,
    this.tamanyo = 200,
  });

  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      glowColor: color,
      glowRadiusFactor: 0.2,
      glowShape: BoxShape.circle,
      duration: const Duration(milliseconds: 2000),
      repeat: true,
      startDelay: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      child: Container(
        width: tamanyo,
        height: tamanyo,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color,
              color.withValues(alpha: 0.7), // Un toque sutil al gradiente
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: accion,
            splashColor: Colors.white.withValues(alpha: 0.3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icono, size: tamanyo * 0.3, color: Colors.white),
                const SizedBox(height: 10),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      texto,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: tamanyo * 0.1, // Texto bien legible
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 4,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
