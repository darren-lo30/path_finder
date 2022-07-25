import 'dart:math';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Given a mode of transportation and measure (either distance or time), it calculates a random path
// from the current location that fits within the measure constraint using the given mode of transportation
//
int generateNumWaypoints() {
  Random rand = Random();

  const int minWaypoints = 2;
  const int maxWaypoints = 8;

  return rand.nextInt(maxWaypoints - minWaypoints) + minWaypoints;
}

// Calculates the distance between two latitude longitude coordinates
double calculateDistance(LatLng point1, LatLng point2) {
  double lat1 = point1.latitude;
  double lon1 = point1.longitude;

  double lat2 = point2.latitude;
  double lon2 = point2.longitude;

  double p = 0.017453292519943295;
  double a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

// Calculates the distance of a polyline path to determine the length of the route
double calculatePathDistance(List<LatLng> polylinePath) {
  double totalDistance = 0;

  for (int i = 0; i < polylinePath.length - 1; i++) {
    totalDistance += calculateDistance(polylinePath[i], polylinePath[i + 1]);
  }

  return totalDistance;
}

double generateRotation(int numWaypoints) {
  Random rand = Random();

  // maximum nui
  return rand.nextDouble();
}

List<LatLng> generateRoute(
    LatLng base, double distance, TravelMode travelMode) {
  return [LatLng(43.894544, -79.419335), LatLng(43.873491, -79.396553)];
}
