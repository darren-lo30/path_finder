import 'package:flutter/material.dart';

class DistanceSelector extends StatelessWidget {
  const DistanceSelector(
      {Key? key, required this.distance, required this.updateDistance})
      : super(key: key);

  final void Function(double) updateDistance;
  final double distance;

  static const int minDistance = 1;
  static const int maxDistance = 20;
  // Ensures that the slider moves up by 0.5
  static const int numDivisions = (maxDistance - minDistance) * 2;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTickMarkColor: Colors.transparent,
          inactiveTickMarkColor: Colors.transparent,
        ),
        child: Slider(
            value: distance,
            onChanged: (newDistance) {
              updateDistance(newDistance);
            },
            divisions: numDivisions,
            label: distance.toStringAsFixed(1),
            min: minDistance.toDouble(),
            max: maxDistance.toDouble()));
  }
}
