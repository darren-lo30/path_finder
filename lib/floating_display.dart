import 'package:flutter/material.dart';

class FloatingDisplay extends StatelessWidget {
  const FloatingDisplay({Key? key, required this.routeDistance})
      : super(key: key);

  final double routeDistance;

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
                child: Text("$routeDistance km",
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold)))));
  }
}
