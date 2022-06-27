import 'package:flutter/material.dart';
import 'package:walk_finder/info_sheet.dart';
import 'package:walk_finder/map.dart';
import 'package:walk_finder/options.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TransportationMode selectedTransportationMode = TransportationMode.walk;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "PathFinder",
        home: Stack(children: <Widget>[
          const MapView(),
          InfoSheet(updateTransportationMode:
              (TransportationMode transportationMode) {
            setState(() {
              selectedTransportationMode = transportationMode;
            });
          }),
        ]));
  }
}
