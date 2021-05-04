import 'package:firebase_auth/firebase_auth.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_avanzado/Place/model/place.dart';
import 'package:platzi_trips_avanzado/User/model/user.dart';
import 'package:platzi_trips_avanzado/User/repository/auth_repository.dart';
import 'package:platzi_trips_avanzado/User/repository/cloud_firestore_repository.dart';

class UserBloc implements Bloc {
  //Instanciamos la clase repositorio creana en repository/auth_repository.dart
  final _auth_repository = AuthRepository();

  //Flujo de datos - Streams
  //Stream - Firebase
  //StreamController
  Stream<User> streamFirebase = FirebaseAuth.instance.authStateChanges();
  Stream<User> get authStatus => streamFirebase;

  //Casis uso
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

  @override
  void dispose() {}
}
