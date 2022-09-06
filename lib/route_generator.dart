import 'dart:math';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:walk_finder/pair.dart';
import 'package:flutter_config/flutter_config.dart';

// Given a mode of transportation and measure (either distance or time), it calculates a random path
// from the current location that fits within the measure constraint using the given mode of transportation
int generateNumWaypoints() {
  Random rand = Random();

  const int minWaypoints = 2;
  const int maxWaypoints = 8;

  return rand.nextInt(maxWaypoints - minWaypoints) + minWaypoints;
}

// Calculates the distance between two latitude longitude coordinates
// Returns in meters
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
// Returns in meters
double calculatePathDistance(List<LatLng> route) {
  double totalDistance = 0;

  for (int i = 0; i < route.length - 1; i++) {
    totalDistance += calculatePointDistance(route[i], route[i + 1]);
  }

  return totalDistance;
}

// Given a latitude and longitude, calculates a new latitude and longitude offset by some number of meters along the latitudinal and longitudinal axes
LatLng calculateLatLngOffset(LatLng base, double dLat, double dLon) {
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
    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          FlutterConfig.get('DIRECTIONS_API_KEY'),
          PointLatLng(waypoints[i].latitude, waypoints[i].longitude),
          PointLatLng(waypoints[i + 1].latitude, waypoints[i + 1].longitude),
          travelMode: travelMode);
      for (PointLatLng point in result.points) {
        route.add(LatLng(point.latitude, point.longitude));
      }
    } catch (e) {
      rethrow;
    }
  }

  return route;
}

// Everything is calculated in meters
// Procedurally generates a route by continuously refining it to get closer and closer to the defined distance
// Randomly moves waypoints away or towards the home location to generate a new route every time
Future<List<LatLng>> generateRoute(
    LatLng home, double distance, TravelMode travelMode) async {
  // The number of refinement cycles to run
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
    try {
      route = await generateWaypointPath(waypoints, travelMode);
    } catch (e) {
      rethrow;
    }

    calculatedRouteDistance = calculatePathDistance(route);
  }

  return route;
}
