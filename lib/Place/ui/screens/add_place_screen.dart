import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_avanzado/Place/model/place.dart';
import 'package:platzi_trips_avanzado/Place/ui/widgets/card_image.dart';
import 'package:platzi_trips_avanzado/Place/ui/widgets/title_input_location.dart';
import 'package:platzi_trips_avanzado/User/bloc/bloc_user.dart';
import 'package:platzi_trips_avanzado/widgets/button_purple.dart';
import 'dart:io';

import 'package:platzi_trips_avanzado/widgets/gradient_back.dart';
import 'package:platzi_trips_avanzado/widgets/text_input.dart';
import 'package:platzi_trips_avanzado/widgets/title_header.dart';

class AddPlaceScreen extends StatefulWidget {
  File image;

  AddPlaceScreen({Key key, this.image});

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _controllerTitlePlace = TextEditingController();
  final _controllerDescriptionPlace = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);

    return Scaffold(
      body: Stack(
        children: [
          GradientBack(
            height: 300.0,
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(top: 25.0, left: 5.0),
                child: SizedBox(
                  height: 45.0,
                  width: 45.0,
                  child: IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                      size: 45.0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(top: 45.0, left: 20.0, right: 10.0),
                  child: TitleHeader(
                    title: "Add a new place",
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 120.0, bottom: 20.0),
            child: ListView(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: CardImageWithFabIcon(
                    pathImage: widget.image.path,
                    internet: false,
                    iconData: Icons.camera_alt,
                    width: 350.0,
                    height: 250.0,
                    left: 0,
                    onPressedFabIcon: () {},
                  ),
                ), //Foto
                Container(
                  margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: TextInput(
                    hintText: "Title",
                    inputType: null,
                    maxLines: 1,
                    controller: _controllerTitlePlace,
                  ),
                ),
                TextInput(
                    hintText: "Description",
                    inputType: TextInputType.multiline,
                    maxLines: 4,
                    controller: _controllerDescriptionPlace),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: TextInputLocation(
                    hintText: "Add Location",
                    iconData: Icons.location_on,
                  ),
                ),
                Container(
                  width: 70.0,
                  child: ButtonPurple(
                    buttonText: "Add Place",
                    onPressed: () {
                      //ID del usuario logueado
                      userBloc.currentUsuario().then((User user) {
                        if (user != null) {
                          String uid = user.uid;
                          String path =
                              "${uid}/${DateTime.now().toString()}.jpg";
                          //1. Firebase Storage
                          userBloc
                              .uploadFile(path, widget.image)
                              .then((UploadTask uploadTask) {
                            uploadTask.then((TaskSnapshot taskSnapshot) {
                              taskSnapshot.ref
                                  .getDownloadURL()
                                  .then((urlImage) {
                                //2.0 Cloud Firestore
                                //Place - title, description, url, userOwner, likes
                                print("URLIMAGE_${urlImage}");
                                userBloc
                                    .updatePlaceData(Place(
                                        name: _controllerTitlePlace.text,
                                        description:
                                            _controllerDescriptionPlace.text,
                                        urlImage: urlImage,
                                        likes: 0))
                                    .whenComplete(() {
                                  print("Termino");
                                  Navigator.pop(context);
                                });
                              });
                            });
                          });
                        }
                      });
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
