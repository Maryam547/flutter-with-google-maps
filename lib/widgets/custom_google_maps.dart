import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition initialCameraPosition;
  @override
  void initState() {
    initialCameraPosition = CameraPosition(
        zoom: 6, target: LatLng(26.907961122686494, 29.744708868142794));

    super.initState();
  }

  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }

  late GoogleMapController googleMapController;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
            onMapCreated: (controller) {
              googleMapController = controller;
              initMapStyle();
            },
            cameraTargetBounds: CameraTargetBounds(LatLngBounds(
                southwest: LatLng(22.02998949642134, 24.992430097993548),
                northeast: LatLng(31.252231480901735, 34.103952406309595))),
            initialCameraPosition: initialCameraPosition),
        Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                CameraPosition newLocation = CameraPosition(
                    target: LatLng(29.302151078982988, 30.836948068644496),
                    zoom: 12);
                googleMapController
                    .animateCamera(CameraUpdate.newCameraPosition(newLocation));
              },
              child: Text('Change Location'),
            ))
      ],
    );
  }

  void initMapStyle() async {
    var nightMapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styls/night_map_style.json');
    googleMapController.setMapStyle(nightMapStyle);
  }
}

//world view 0->3
//country view 4->6
//city view 10->12
//street view 13->17
//building view 18->20
