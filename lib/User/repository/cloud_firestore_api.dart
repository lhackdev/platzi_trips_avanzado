import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:platzi_trips_avanzado/Place/model/place.dart';
import 'package:platzi_trips_avanzado/Place/ui/widgets/card_image.dart';
import 'package:platzi_trips_avanzado/User/model/user.dart';
import 'package:platzi_trips_avanzado/User/ui/widgets/profile_place.dart';

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
    // DocumentReference _userRef = _db.collection(this.USERS).doc(user.uid);
    await refPlaces.add({
      'name': place.name,
      'description': place.description,
      'likes': place.likes,
      'urlImage': place.urlImage,
      'userOwner': _db.doc("${USERS}/${user.uid}"),
    }).then((DocumentReference dr) {
      dr.get().then((DocumentSnapshot snapshot) {
        DocumentReference refUsers = _db.collection(USERS).doc(user.uid);
        refUsers.update({
          'myPlaces':
              FieldValue.arrayUnion([_db.doc("${PLACES}/${snapshot.id}")])
        });
      });
    });
  }

  //
  List<ProfilePlace> buildMyPlaces(List<DocumentSnapshot> placesListSnapshot) {
    List<ProfilePlace> profilePlaces = [];
    placesListSnapshot.forEach((p) {
      profilePlaces.add(ProfilePlace(Place(
          name: p.data()['name'],
          description: p.data()['description'],
          urlImage: p.data()['urlImage'],
          likes: p.data()['likes'])));
    });

    return profilePlaces;
  }

  // List<CardImageWithFabIcon> buildPlaces(
  //     List<DocumentSnapshot> placesListSnapshot) {
  //   List<CardImageWithFabIcon> placesCard = [];
  //   double width = 300.0;
  //   double height = 350.0;
  //   double left = 20.0;
  //   IconData iconData = Icons.favorite_border_outlined;
  //   placesListSnapshot.forEach((p) {
  //     placesCard.add(
  //       CardImageWithFabIcon(
  //         pathImage: p.data()["urlImage"],
  //         width: width,
  //         height: height,
  //         left: left,
  //         onPressedFabIcon: () {
  //           likePlace(p.id);
  //         },
  //         iconData: iconData,
  //       ),
  //     );
  //   });

  //   return placesCard;
  // }

  List<Place> buildPlaces(List placesListSnapshot, Usuario user) {
    List<Place> places = [];

    placesListSnapshot.forEach((p) {
      Place place = Place(
          id: p.id,
          name: p.data()["name"],
          description: p.data()["description"],
          urlImage: p.data()["urlImage"],
          likes: p.data()["likes"]);
      List usersLikedRefs = p.data()["usersLiked"];
      place.liked = false;
      usersLikedRefs?.forEach((drUL) {
        if (user.uid == drUL.id) {
          place.liked = true;
        }
      });
      places.add(place);
    });
    return places;
  }

  // Future likePlace(String idPlace) async {
  //   _db.runTransaction((transaction) async {
  //     DocumentSnapshot placeDS =
  //         await _db.collection(this.PLACES).doc(idPlace).get();
  //     await transaction
  //         .update(placeDS.reference, {"likes": placeDS.data()['likes'] + 1});
  //   });
  // }
  Future likePlace(Place place, String uid) async {
    _db.runTransaction((transaction) async {
      DocumentSnapshot placeDS =
          await _db.collection(this.PLACES).doc(place.id).get();
      await transaction.update(placeDS.reference, {
        "likes": place.liked
            ? placeDS.data()['likes'] + 1
            : placeDS.data()['likes'] - 1,
        'usersLiked': place.liked
            ? FieldValue.arrayUnion([_db.doc("${USERS}/${uid}")])
            : FieldValue.arrayRemove([_db.doc("${USERS}/${uid}")])
      });
    });
  }
}
