import 'dart:async';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:siga/pages/root_app.dart';
import 'package:siga/widgets/event_item.dart';

class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MapPageSate();
  }
}

class _MapPageSate extends State<MapPage> {
  late LocationData _currentPosition;
  late String _address;
  late Marker marker;
  LatLng _initialPosition = LatLng(40.6412, -8.65362);
  Set<Marker> markers = {};
  List<EventItem> events = [];

  Location location = Location();
  late GoogleMapController mapController;

  List<Marker> list = [
    // Marker(
    //   markerId: MarkerId('Marker1'),
    //   position: LatLng(40.63317310000001, -8.6594933),
    //   infoWindow: InfoWindow(title: 'Caralhoooooooooooooooo 1'),
    //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    // ),
    // Marker(
    //   markerId: MarkerId('Marker2'),
    //   position: LatLng(31.110484, 72.384598),
    //   infoWindow: InfoWindow(title: 'Business 2'),
    //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    // ),
  ];

  getEvents() async {
    QuerySnapshot snapshot =
        await eventsRef.orderBy('timestamp', descending: true).get();

    events = snapshot.docs.map((doc) => EventItem.fromDocument(doc)).toList();

    events.forEach((EventItem e) => list.add(Marker(
          markerId: MarkerId(e.eventId),
          position: LatLng(e.lat, e.lng),
          infoWindow: InfoWindow(title: e.caption),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        )));

    print(snapshot.docs);
    setState(() {
      markers.addAll(list);
    });
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      getEvents();
    });
    getLoc();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    Stream<LocationData> change = location.onLocationChanged;

    change.listen((l) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(l.latitude!, l.longitude!),
            zoom: 15.0,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    getEvents();
    return new Scaffold(
      body: GoogleMap(
        markers: markers,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 11.0,
        ),
        mapType: MapType.terrain,
        myLocationEnabled: true,
      ),
    );
  }

  getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await location.getLocation();
    _initialPosition =
        LatLng(_currentPosition.latitude!, _currentPosition.longitude!);
    location.onLocationChanged.listen((LocationData currentLocation) {
      print("Current location \n");
      print("${currentLocation.longitude} : ${currentLocation.longitude}");
      setState(() {
        _currentPosition = currentLocation;
        _initialPosition =
            LatLng(_currentPosition.latitude!, _currentPosition.longitude!);
      });
    });
  }
}
