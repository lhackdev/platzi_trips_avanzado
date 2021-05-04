import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:platzi_trips_avanzado/Place/model/place.dart';
import 'package:platzi_trips_avanzado/User/model/user.dart';

class CloudFirestoreAPI {
  //VARIABLES CONSTANTES PARA LOS NOMBRES DE LAS COLECCIONES EN FIRESTORES
  final String USERS = "users";
  final String PLACES = "places";

  //Instanciamos las clases a utilizar
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Registro y actualizacion de usuarios en firestore
  void updateUserData(Usuario user) async {
    DocumentReference refUser = _db.collection(USERS).doc(user.uid);
    return await refUser.set({
      'uid': user.uid,
      'name': user.name,
      'email': user.email,
      'photoURL': user.photoURL,
      'myPlaces': user.myPlaces,
      'myFavoritePlaces': user.myFavoritePlaces,
      'lastSignIn': DateTime.now()
    }, SetOptions(merge: true));
  }

  //Registro de places en firestore
  Future<void> updatePlaceData(Place place) async {
    CollectionReference refPlaces = _db.collection(PLACES);
    User user = await _auth.currentUser;
    DocumentReference _userRef = _db.collection(this.USERS).doc(user.uid);
    await refPlaces.add({
      'name': place.name,
      'description': place.description,
      'likes': place.likes,
      'userOwner': _userRef
    });
  }
}
