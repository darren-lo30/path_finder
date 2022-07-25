import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key, required this.routeCoordinates}) : super(key: key);

  final List<LatLng> routeCoordinates;

  @override
  State<MapView> createState() => _MapState();
}

class _MapState extends State<MapView> {
  late GoogleMapController _mapController;

  final LatLng _currentLatLng = const LatLng(43.894544, -79.419335);
  final Location _currentLocation = Location();

  Polyline _createRoutePolyline() {
    return Polyline(
      color: Colors.red,
      points: widget.routeCoordinates,
      width: 3,
      polylineId: const PolylineId('poly'),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    // _currentLocation.onLocationChanged.listen((location) {
    //   _currentLatLng = LatLng(location.latitude!, location.longitude!);
    //   _mapController.animateCamera(CameraUpdate.newCameraPosition(
    //       CameraPosition(target: _currentLatLng, zoom: 18.0)));
    // });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(target: _currentLatLng, zoom: 18.0),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: false,
      polylines: <Polyline>{_createRoutePolyline()},
    );
  }
}
