import 'package:flutter/material.dart';

class FloatingDisplay extends StatelessWidget {
  const FloatingDisplay({Key? key, required this.routeDistance})
      : super(key: key);

  final double routeDistance;

  String formatDistance(double distance) {
    if (distance < 1000) return "${(distance).toStringAsFixed(0)} m";
    return "${(distance / 1000).toStringAsFixed(2)} km";
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topCenter,
        child: Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Text(formatDistance(routeDistance),
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold)))));
  }
}
