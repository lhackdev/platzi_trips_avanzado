import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_avanzado/Place/model/place.dart';
import 'package:platzi_trips_avanzado/User/bloc/bloc_user.dart';
import 'package:platzi_trips_avanzado/User/model/user.dart';
import 'card_image.dart';

class CardImageList extends StatefulWidget {
  Usuario usuario;

  CardImageList({this.usuario});

  @override
  _CardImageListState createState() => _CardImageListState();
}

class _CardImageListState extends State<CardImageList> {
  UserBloc userBloc;
  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    return Container(
        height: 350.0,
        child: StreamBuilder(
          stream: userBloc.placesStream,
          builder: (context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              case ConnectionState.none:
                return CircularProgressIndicator();
              case ConnectionState.active:
                return listViewPlaces(
                    userBloc.buildPlaces(snapshot.data.docs, widget.usuario));
              case ConnectionState.done:
                return listViewPlaces(
                    userBloc.buildPlaces(snapshot.data.docs, widget.usuario));
              default:
            }
          },
        ));
  }

  // Widget listViewPlaces(List<CardImageWithFabIcon> placeCard) {
  //   return ListView(
  //     padding: EdgeInsets.all(25.0),
  //     scrollDirection: Axis.horizontal,
  //     children: placeCard,
  //   );
  // }

  void setLiked(Place place) {
    setState(() {
      place.liked = !place.liked;
      userBloc.likePlace(place, widget.usuario.uid);
      place.likes = place.liked ? place.likes + 1 : place.likes - 1;
      userBloc.placeSelectedSink.add(place);
    });
  }

  Widget listViewPlaces(List<Place> places) {
    return ListView(
      padding: EdgeInsets.all(25.0),
      scrollDirection: Axis.horizontal,
      children: places.map((place) {
        return GestureDetector(
          onTap: () {
            print("CLICK PLACE: ${place.name}");
            userBloc.placeSelectedSink.add(place);
          },
          child: CardImageWithFabIcon(
            pathImage: place.urlImage,
            width: 300.0,
            height: 250.0,
            left: 20.0,
            internet: true,
            iconData:
                !place.liked ? Icons.favorite_border_outlined : Icons.favorite,
            onPressedFabIcon: () {
              setLiked(place);
            },
          ),
        );
      }).toList(),
    );
  }
}
