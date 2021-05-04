import 'package:platzi_trips_avanzado/Place/model/place.dart';
import 'package:platzi_trips_avanzado/User/model/user.dart';
import 'package:platzi_trips_avanzado/User/repository/cloud_firestore_api.dart';

class CloudFirestoreRepository {
  //Instancia de CloudFirestoreAPI path: repository/cloud_firestore_api.dart
  final _cloudFirestoreAPI = CloudFirestoreAPI();

  //Actualizacion o registro de usuarios
  void updateUserDataFirestore(Usuario user) =>
      _cloudFirestoreAPI.updateUserData(user);

  //Registro de places
  Future<void> updatePlaceData(Place place) =>
      _cloudFirestoreAPI.updatePlaceData(place);
}
