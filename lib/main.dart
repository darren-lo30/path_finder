import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
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

  Future<void> updateRoute() async {
    Location location = Location();
    LocationData locationData = await location.getLocation();

    setState(() {
      routeCoordinates = generateRoute(
          LatLng(locationData.latitude!, locationData.longitude!),
          selectedDistance,
          selectedTravelMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "PathFinder",
        home: Stack(children: <Widget>[
          MapView(
            routeCoordinates: routeCoordinates,
          ),
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
