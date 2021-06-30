import 'package:flutter/material.dart';
import 'package:platzi_trips_avanzado/User/model/user.dart';

class Place {
  String id;
  String name;
  String description;
  String urlImage;
  int likes;
  bool liked;
  // Usuario userOwner;

  Place(
      {Key key,
      @required this.name,
      @required this.description,
      @required this.urlImage,
      this.likes,
      this.liked,
      this.id
      // @required this.userOwner
      });
}
