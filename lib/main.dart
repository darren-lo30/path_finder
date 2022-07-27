import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:walk_finder/floating_display.dart';
import 'package:walk_finder/info_sheet.dart';
import 'package:walk_finder/map.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:walk_finder/route_generator.dart';

Future main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TravelMode selectedTravelMode = TravelMode.walking;
  double selectedDistance = 3.0;
  List<LatLng> routeCoordinates = [];
  double routeDistance = -1.0;

  // Updates the route data using the users desired route distance and current location
  Future<void> updateRoute() async {
    Location location = Location();
    LocationData locationData = await location.getLocation();

    List<LatLng> route = await generateRoute(
        LatLng(locationData.latitude!, locationData.longitude!),
        selectedDistance,
        selectedTravelMode);
    setState(() {
      routeCoordinates = route;
      routeDistance = calculatePathDistance(route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "PathFinder",
        theme: ThemeData(
          fontFamily: 'Raleway',
        ),
        home: Stack(children: <Widget>[
          MapView(
            routeCoordinates: routeCoordinates,
          ),
          // Only displays distance once a route has been generated
          if (routeDistance >= 0) FloatingDisplay(routeDistance: routeDistance),
          InfoSheet(
            updateTravelMode: (TravelMode travelMode) {
              setState(() {
                selectedTravelMode = travelMode;
              });
            },
            updateDistance: (double distance) {
              setState(() {
                selectedDistance = distance;
              });
            },
            updateRoute: updateRoute,
            distance: selectedDistance,
            travelMode: selectedTravelMode,
          ),
        ]));
  }
}
