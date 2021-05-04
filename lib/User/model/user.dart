import 'package:flutter/material.dart';
import 'package:platzi_trips_avanzado/Place/model/place.dart';

class Usuario {
  final String uid;
  final String name;
  final String email;
  final String photoURL;
  final List<Place> myPlaces;
  final List<Place> myFavoritePlaces;

  Usuario(
      {Key key,
      @required this.uid,
      @required this.name,
      @required this.email,
      @required this.photoURL,
      this.myPlaces,
      this.myFavoritePlaces});
}
