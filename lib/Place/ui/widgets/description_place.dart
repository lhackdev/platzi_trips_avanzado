import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_avanzado/Place/model/place.dart';
import 'package:platzi_trips_avanzado/User/bloc/bloc_user.dart';
import 'package:platzi_trips_avanzado/widgets/button_purple.dart';

class DescriptionPlace extends StatelessWidget {
  String namePlace;
  int stars;
  String descriptionPlace;

  DescriptionPlace(this.namePlace, this.stars, this.descriptionPlace);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final star_half = Container(
      margin: EdgeInsets.only(top: 353.0, right: 3.0),
      child: Icon(
        Icons.star_half,
        color: Color(0xFFf2C611),
      ),
    );

    final star_border = Container(
      margin: EdgeInsets.only(top: 353.0, right: 3.0),
      child: Icon(
        Icons.star_border,
        color: Color(0xFFf2C611),
      ),
    );

    final star = Container(
      margin: EdgeInsets.only(top: 353.0, right: 3.0),
      child: Icon(
        Icons.star,
        color: Color(0xFFf2C611),
      ),
    );

    // Widget title_stars() {
    //   final Place place;
    //   title_stars({this.p})
    //   return Row(
    //     children: <Widget>[
    //       Container(
    //         margin: EdgeInsets.only(top: 350.0, left: 20.0, right: 20.0),
    //         child: Text(
    //           namePlace,
    //           style: TextStyle(
    //               fontFamily: "Lato",
    //               fontSize: 30.0,
    //               fontWeight: FontWeight.w900),
    //           textAlign: TextAlign.left,
    //         ),
    //       ),
    //       Row(
    //         children: <Widget>[star, star, star, star, star_half],
    //       )
    //     ],
    //   );
    // }

    Widget description(String _descriptionPlace) {
      return Container(
        margin: new EdgeInsets.only(top: 350.0, left: 20.0, right: 20.0),
        child: new Text(
          _descriptionPlace,
          style: const TextStyle(
              fontFamily: "Lato",
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF56575a)),
        ),
      );
    }

    UserBloc userBloc = BlocProvider.of(context);

    return StreamBuilder(
        stream: userBloc.placeSelectedStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Place place = snapshot.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                description(place.description),
                ButtonPurple(buttonText: "Navigate", onPressed: () {})
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 400.0, left: 20.0, right: 20.0),
                  child: Text(
                    "Selecciona un lugar",
                    style: TextStyle(
                        fontFamily: "Lato",
                        fontSize: 30.0,
                        fontWeight: FontWeight.w900),
                    textAlign: TextAlign.left,
                  ),
                )
              ],
            );
          }
          // return Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: <Widget>[
          //     title_stars,
          //     description,
          //     ButtonPurple(
          //       buttonText: "Navigate",
          //       onPressed: () {},
          //     )
          //   ],
          // );
        });
  }
}
