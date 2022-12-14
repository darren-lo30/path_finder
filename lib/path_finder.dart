import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:walk_finder/floating_display.dart';
import 'package:walk_finder/info_sheet.dart';
import 'package:walk_finder/map.dart';
import 'package:walk_finder/route_generator.dart';

class PathFinder extends StatefulWidget {
  const PathFinder({Key? key}) : super(key: key);

  @override
  State<PathFinder> createState() => _PathFinderState();
}

class _PathFinderState extends State<PathFinder> {
  // Allows rebuilding of bottom modal sheet
  final ValueNotifier<TravelMode> travelMode =
      ValueNotifier<TravelMode>(TravelMode.walking);
  final ValueNotifier<double> distance = ValueNotifier<double>(2.0);

  List<LatLng> routeCoordinates = [];
  double routeDistance = -1.0;
  bool isGeneratingRoute = false;

  // Updates the route data using the users desired route distance and current location
  Future<void> updateRoute() async {
    Location location = Location();
    LocationData locationData = await location.getLocation();

    setState(() {
      isGeneratingRoute = true;
    });

    try {
      List<LatLng> route = await generateRoute(
          LatLng(locationData.latitude!, locationData.longitude!),
          1000 * distance.value,
          travelMode.value);
      setState(() {
        routeCoordinates = route;
        routeDistance = calculatePathDistance(route);
        isGeneratingRoute = false;
      });
    } catch (e) {
      setState(() {
        isGeneratingRoute = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      MapView(
        routeCoordinates: routeCoordinates,
      ),
      // Only displays distance once a route has been generated
      if (routeDistance >= 0) FloatingDisplay(routeDistance: routeDistance),
      if (isGeneratingRoute)
        const Align(
            alignment: Alignment.center, child: CircularProgressIndicator()),
      InfoSheet(
        updateTravelMode: (TravelMode newTravelMode) {
          setState(() {
            travelMode.value = newTravelMode;
          });
        },
        updateDistance: (double newDistance) {
          setState(() {
            distance.value = newDistance;
          });
        },
        distance: distance,
        travelMode: travelMode,
        updateRoute: updateRoute,
      ),
    ]);
  }
}
