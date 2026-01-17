import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:park_snap/firebase_options.dart';
import 'package:park_snap/pantallas/pant_splash.dart';
import 'package:park_snap/provider/provider_aparcamiento.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    GoogleProvider(clientId: ''),
  ]);
  runApp(const ParkSnapApp());
}

class ParkSnapApp extends StatelessWidget {
  const ParkSnapApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Envolvemos la app en ChangeNotifierProvider para que provider sea accesible en toda la app
    return ChangeNotifierProvider(
      create: (context) => ProviderAparcamiento(),
      child: MaterialApp(
        title: "ParkSnap",
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurpleAccent,
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF1E1E2C),
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF2D2D44),
            elevation: 0,
            centerTitle: true,
          ),
        ),

        home: const PantallaSplash(),
      ),
    );
  }
}
