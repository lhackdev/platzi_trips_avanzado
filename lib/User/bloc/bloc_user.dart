import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_avanzado/Place/model/place.dart';
import 'package:platzi_trips_avanzado/Place/repository/firebase_storage_repository.dart';
import 'package:platzi_trips_avanzado/Place/ui/widgets/card_image.dart';
import 'package:platzi_trips_avanzado/User/model/user.dart';
import 'package:platzi_trips_avanzado/User/repository/auth_repository.dart';
import 'package:platzi_trips_avanzado/User/repository/cloud_firestore_api.dart';
import 'package:platzi_trips_avanzado/User/repository/cloud_firestore_repository.dart';
import 'package:platzi_trips_avanzado/User/ui/widgets/profile_place.dart';

class UserBloc implements Bloc {
  //Instanciamos la clase repositorio creana en repository/auth_repository.dart
  final _auth_repository = AuthRepository();

  //Flujo de datos - Streams
  //Stream - Firebase
  //StreamController
  Stream<User> streamFirebase = FirebaseAuth.instance.authStateChanges();
  Stream<User> get authStatus => streamFirebase;

  StreamController placeSelectedStreamController = StreamController();
  Stream get placeSelectedStream => placeSelectedStreamController.stream;
  StreamSink get placeSelectedSink => placeSelectedStreamController.sink;

  //Obtener datos del usuario logueado
  Future<User> currentUsuario() async {
    User user = FirebaseAuth.instance.currentUser;
    return user;
  }

  //Casos uso
  //1. SignIn a la aplicacion Google
  Future<UserCredential> signIn() => _auth_repository.signInFirebase();

  //2. Cerrar sesion
  signOut() => _auth_repository.signOut();

  //3. Registrar usuario en base de datos
  final _cloudFirestoreRespository = CloudFirestoreRepository();
  void updateUserData(Usuario user) =>
      _cloudFirestoreRespository.updateUserDataFirestore(user);

  //4. Registrar place en base de datos
  Future<void> updatePlaceData(Place place) =>
      _cloudFirestoreRespository.updatePlaceData(place);

  //5. Obtener place de la base de datos Firestore
  Stream<QuerySnapshot> placesListStream = FirebaseFirestore.instance
      .collection(CloudFirestoreAPI().PLACES)
      .snapshots();

  Stream<QuerySnapshot> get placesStream => placesListStream;

  //Guardar imagen en Firebase Storage
  final _firebaseStorageRepository = FirebaseStorageRepository();
  Future<UploadTask> uploadFile(String path, File image) =>
      _firebaseStorageRepository.uploadFile(path, image);

  //Listar Places
  List<ProfilePlace> buildMyPlaces(List<DocumentSnapshot> placesListSnapshot) =>
      _cloudFirestoreRespository.buildMyPlaces(placesListSnapshot);

  //Listar todos los Places
  List<Place> buildPlaces(List placesListSnapshot, Usuario user) =>
      _cloudFirestoreRespository.buildPlaces(placesListSnapshot, user);

  Stream<QuerySnapshot> myPlacesListStream(String uid) => FirebaseFirestore
      .instance
      .collection(CloudFirestoreAPI().PLACES)
      .where("userOwner",
          isEqualTo: FirebaseFirestore.instance
              .doc("${CloudFirestoreAPI().USERS}/${uid}"))
      .snapshots();

  Future likePlace(Place place, String uid) =>
      _cloudFirestoreRespository.likePlace(place, uid);

  @override
  void dispose() {
    placeSelectedStreamController.close();
  }
}
