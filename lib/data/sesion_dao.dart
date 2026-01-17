import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:park_snap/modelos/sesion_aparcamiento.dart'
    show SesionAparcamiento;

class SesionDao {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //Stream para que se actualize cuando hay datos en la nuebe
  Stream<List<SesionAparcamiento>> getSesiones(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('sesiones')
        .orderBy('fecha', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => SesionAparcamiento.fromFirestore(doc))
              .toList(),
        );
  }

  Future<void> addSesion(String userId, Map<String, dynamic> data) {
    return _db.collection('users').doc(userId).collection('sesiones').add(data);
  }

  Future<void> deleteSesion(String userId, String sesionId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('sesiones')
        .doc(sesionId)
        .delete();
  }

  Future<void> updateSesion(
    String userId,
    String sesionId,
    Map<String, dynamic> data,
  ) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('sesiones')
        .doc(sesionId)
        .update(data);
  }
}
