import 'package:flutter/material.dart';

/// Muestra un dialogo temporal
void mostrarDialogoAutoCierre({
  required BuildContext context,
  required String texto,
  required IconData icono,
  required Color colorIcono,
  required VoidCallback onClosed,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black12,
    builder: (ctx) => Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 80.0),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 200,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icono, color: colorIcono, size: 40),
                const SizedBox(height: 10),
                Text(
                  texto,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  // Cerrar tras 1.5s
  Future.delayed(const Duration(milliseconds: 1500), () {
    if (context.mounted) {
      Navigator.of(context).pop();
      onClosed(); // Ejecuta la accion final (navegar, borrar, etc)
    }
  });
}
