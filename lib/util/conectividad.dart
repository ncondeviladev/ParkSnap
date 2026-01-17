import 'package:connectivity_plus/connectivity_plus.dart';

class Conectividad {
  //Comprueba si el dispositivo tiene conexion a internet
  static Future<bool> tieneConexion() async {
    final List<ConnectivityResult> resultados = await Connectivity()
        .checkConnectivity();

    if (resultados.contains(ConnectivityResult.mobile) ||
        resultados.contains(ConnectivityResult.wifi) ||
        resultados.contains(ConnectivityResult.ethernet)) {
      return true;
    }

    return false;
  }
}
