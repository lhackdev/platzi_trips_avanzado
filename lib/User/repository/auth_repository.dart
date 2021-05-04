import 'package:firebase_auth/firebase_auth.dart';
import 'package:platzi_trips_avanzado/User/repository/firebase_auth.dart';

class AuthRepository {
  //Instanciamos la clase creada repository/firebase_auth.dart
  final _firebaseAuthAPI = FirebaseAuthAPI();

  //SignIn - Iniciar session
  Future<UserCredential> signInFirebase() => _firebaseAuthAPI.singIn();

  //SignOut - Cerrar session
  signOut() => _firebaseAuthAPI.signOut();
}
