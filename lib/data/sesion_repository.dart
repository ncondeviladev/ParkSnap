import 'package:park_snap/data/sesion_dao.dart';
import 'package:park_snap/modelos/sesion_aparcamiento.dart';

class SesionRepository {
  static final SesionDao _sesionDao = SesionDao();

  static Stream<List<SesionAparcamiento>> getSesiones(String userId) {
    return _sesionDao.getSesiones(userId);
  }

  static Future<void> addSesion(String userId, SesionAparcamiento sesion) {
    return _sesionDao.addSesion(
      userId,
      sesion.toMap(),
    ); //Le pasamos al dao la sesion convertida a map
  }

  static Future<void> deleteSesion(String userId, String sesionId) {
    return _sesionDao.deleteSesion(userId, sesionId);
  }

  static Future<void> updateSesion(String userId, SesionAparcamiento sesion) {
    return _sesionDao.updateSesion(
      userId,
      sesion.id!,
      sesion.toMap(),
    ); //Le pasamos al dao la sesion convertida a map
  }
}
