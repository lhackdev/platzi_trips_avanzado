import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthAPI {
  //Instanciamos las clases a utilizar
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  //Iniciar session
  Future<UserCredential> singIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;

    UserCredential user = await _auth.signInWithCredential(
        GoogleAuthProvider.credential(
            idToken: gSA.idToken, accessToken: gSA.accessToken));

    return user;
  }

  //Cerrar session
  signOut() async {
    await _auth.signOut().then((value) => print("Session cerrada"));
    googleSignIn.signOut();
    print("Sessiones cerradas");
  }
}
