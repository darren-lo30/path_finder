import 'package:flutter/material.dart';

class DistanceSelector extends StatelessWidget {
  const DistanceSelector(
      {Key? key, required this.updateDistance, required this.distance})
      : super(key: key);

  final void Function(double) updateDistance;
  final double distance;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: distance,
      onChanged: (newDistance) {
        updateDistance(newDistance);
      },
      min: 1.0,
      max: 10.0);
  }
}
