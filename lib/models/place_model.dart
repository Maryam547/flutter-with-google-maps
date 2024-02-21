import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel1 {
  final int id;
  final String name;
  final LatLng latLng;

  PlaceModel1({required this.id, required this.name, required this.latLng});
}

List<PlaceModel1> places = [
  PlaceModel1(
      id: 1,
      name: 'bablo cafe',
      latLng: LatLng(29.302151078982988, 30.836948068644496))

  //بحط هنا اماكن
];
