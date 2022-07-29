import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:walk_finder/pair.dart';

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
// Returns meters
double calculatePointDistance(LatLng point1, LatLng point2) {
  double lat1 = point1.latitude;
  double lon1 = point1.longitude;

  double lat2 = point2.latitude;
  double lon2 = point2.longitude;

  double p = 0.017453292519943295;
  double a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a)) * 1000;
}

// Calculates the distance of a polyline path to determine the length of the route
double calculatePathDistance(List<LatLng> route) {
  double totalDistance = 0;

  for (int i = 0; i < route.length - 1; i++) {
    totalDistance += calculatePointDistance(route[i], route[i + 1]);
  }

  return totalDistance;
}

LatLng calculateLatLngOffset(LatLng base, double dLat, double dLon) {
  // Calculates lat lng offset in meters from anohter lat lng
  const double earthRadius = 6378100;
  return LatLng(
      base.latitude + (dLat / earthRadius) * (180 / pi),
      base.longitude +
          (dLon / earthRadius) * (180 / pi) / cos(base.latitude * pi / 180));
}

// Given waypoints, generates the full path of points between them
Future<List<LatLng>> generateWaypointPath(
    List<LatLng> waypoints, travelMode) async {
  PolylinePoints polylinePoints = PolylinePoints();

  List<LatLng> route = [];
  for (int i = 0; i < waypoints.length - 1; i++) {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        dotenv.env['DIRECTIONS_API_KEY']!,
        PointLatLng(waypoints[i].latitude, waypoints[i].longitude),
        PointLatLng(waypoints[i + 1].latitude, waypoints[i + 1].longitude),
        travelMode: travelMode);

    for (PointLatLng point in result.points) {
      route.add(LatLng(point.latitude, point.longitude));
    }
  }

  return route;
}

// Everything in meters
Future<List<LatLng>> generateRoute(
    LatLng home, double distance, TravelMode travelMode) async {
  const int numCycles = 10;
  List<Pair> offsets = List<Pair>.generate(4, (_) => Pair(0.0, 0.0));
  List<Pair> directions = [Pair(-1, 1), Pair(1, 1), Pair(1, -1), Pair(-1, -1)];

  late List<LatLng> route;
  double calculatedRouteDistance = 0.0;

  for (int i = 0; i < numCycles; i++) {
    // Adjust waypoints accordingly and randomly (move them inwards if the distanceDifference is negative, outwards if positive);
    double distanceDifference = distance - calculatedRouteDistance;

    Random rand = Random();
    for (Pair offset in offsets) {
      offset.first += (rand.nextDouble() + 1.0) * distanceDifference / 32;
      offset.second += (rand.nextDouble() + 1.0) * distanceDifference / 32;
    }

    List<LatLng> waypoints = [home];

    for (int waypointIdx = 0; waypointIdx < 4; waypointIdx++) {
      double dLat =
          (directions[waypointIdx].first * offsets[waypointIdx].first);
      double dLon =
          directions[waypointIdx].second * offsets[waypointIdx].second;
      waypoints.add(calculateLatLngOffset(home, dLat, dLon));
    }

    waypoints.add(home);

    route = await generateWaypointPath(waypoints, travelMode);

    calculatedRouteDistance = calculatePathDistance(route);
  }

  return route;
}
