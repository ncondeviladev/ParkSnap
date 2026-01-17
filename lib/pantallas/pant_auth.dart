import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:park_snap/pantallas/pant_inicio.dart';

class PantallaAuth extends StatelessWidget {
  const PantallaAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      providers: [
        EmailAuthProvider(),
        GoogleProvider(clientId: ''),
      ],
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          //Si el login es correcto salta a incio
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PantallaInicio()),
          );
        }),
      ],
    );
  }
}
