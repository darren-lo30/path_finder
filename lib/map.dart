import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapState();
}

class _MapState extends State<MapView> {
  late GoogleMapController _mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);
  final Location _currentLocation = Location();

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _currentLocation.onLocationChanged.listen((location) {
      _mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(location.latitude!, location.longitude!),
              zoom: 18.0)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),
    );
  }
}
