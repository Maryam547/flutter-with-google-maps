import 'package:flutter/material.dart';
import 'package:flutter_with_google_maps/utils/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition initialCameraPosition;
  late LocationService locationService;
  //late Location location;
  @override
  void initState() {
    initialCameraPosition = CameraPosition(
        zoom: 6, target: LatLng(26.907961122686494, 29.744708868142794));

    //location = Location();
    locationService = LocationService();

    initMarkers();
    updateMyLocation();
    super.initState();
  }

  //void dispose() {
  //googleMapController?.dispose();
  //super.dispose();
  //}
  bool isFirstCall = true;
  GoogleMapController? googleMapController;

  Set<Marker> markers = {};
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
            zoomControlsEnabled: false,
            markers: markers,
            onMapCreated: (controller) {
              googleMapController = controller;
              initMapStyle();
            },
            cameraTargetBounds: CameraTargetBounds(LatLngBounds(
                southwest: LatLng(22.02998949642134, 24.992430097993548),
                northeast: LatLng(31.252231480901735, 34.103952406309595))),
            initialCameraPosition: initialCameraPosition),
        /*Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: 
            ElevatedButton(
              onPressed: () {
                CameraPosition newLocation = CameraPosition(target: LatLng(29.302151078982988, 30.836948068644496),zoom: 12);
                googleMapController.animateCamera(CameraUpdate.newCameraPosition(newLocation));
              },
              child: Text('Change Location'),
            )
            )*/
      ],
    );
  }

  void initMapStyle() async {
    var nightMapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styls/night_map_style.json');
    googleMapController!.setMapStyle(nightMapStyle);
  }

  void initMarkers() {
    var myMaker = Marker(
        markerId: MarkerId("1"),
        position: LatLng(29.302151078982988, 30.836948068644496));
  }

  /*Future<void> checkAndRequestLocationService() async {
    var isServiceEnabled = await location.serviceEnabled();
    if (!isServiceEnabled) {
      isServiceEnabled = await location.requestService();
      if (!isServiceEnabled) {
        //show error
      }
    }
    //checkAndRequestLocationPermission();
  }*/

  /*Future<bool> checkAndRequestLocationPermission() async {
    var permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.deniedForever) {
      return false;
    }
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }*/

  void updateMyLocation() async {
    await locationService.checkAndRequestLocationService();
    var hasPermission =
        await locationService.checkAndRequestLocationPermission();
    if (hasPermission) {
      locationService.getRealTimeLocationData((LocationData) {
        setMyLocationMarker(LocationData);

        //setMyCameraPosition(LocationData);
      });
    } else {}
  }

  void updateMyCamera(LocationData LocationData) {
    //var cameraPosition = CameraPosition(
    //target: LatLng(LocationData.latitude!, LocationData.longitude!),
    //zoom: 6
    //);

    if (isFirstCall) {
      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(LocationData.latitude!, LocationData.longitude!),
          zoom: 17);
      googleMapController
          ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      isFirstCall = false;
    } else {
      googleMapController?.animateCamera(CameraUpdate.newLatLng(
          LatLng(LocationData.latitude!, LocationData.longitude!)));
    }
  }

  void setMyLocationMarker(LocationData LocationData) {
    var myLocationMarker = Marker(
        markerId: MarkerId('my_Location_Marker'),
        position: LatLng(LocationData.latitude!, LocationData.longitude!));
    markers.add(myLocationMarker);
    //use it to animate myLocationMarker
    setState(() {});
  }
}

//world view 0->3
//country view 4->6
//city view 10->12
//street view 13->17
//building view 18->20

//inquire about location service
//request permission from user
//get location
//display
