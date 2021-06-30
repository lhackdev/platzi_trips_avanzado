import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:platzi_trips_avanzado/Place/model/place.dart';
import 'package:platzi_trips_avanzado/Place/ui/widgets/card_image.dart';
import 'package:platzi_trips_avanzado/User/model/user.dart';
import 'package:platzi_trips_avanzado/User/repository/cloud_firestore_api.dart';
import 'package:platzi_trips_avanzado/User/ui/widgets/profile_place.dart';

class CloudFirestoreRepository {
  //Instancia de CloudFirestoreAPI path: repository/cloud_firestore_api.dart
  final _cloudFirestoreAPI = CloudFirestoreAPI();

  //Actualizacion o registro de usuarios
  void updateUserDataFirestore(Usuario user) =>
      _cloudFirestoreAPI.updateUserData(user);

  //Registro de places
  Future<void> updatePlaceData(Place place) =>
      _cloudFirestoreAPI.updatePlaceData(place);

  List<ProfilePlace> buildMyPlaces(List<DocumentSnapshot> placesListSnapshot) =>
      _cloudFirestoreAPI.buildMyPlaces(placesListSnapshot);

  List<Place> buildPlaces(List placesListSnapshot, Usuario user) =>
      _cloudFirestoreAPI.buildPlaces(placesListSnapshot, user);

  Future likePlace(Place place, String uid) =>
      _cloudFirestoreAPI.likePlace(place, uid);
}
