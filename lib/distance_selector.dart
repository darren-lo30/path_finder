import 'package:flutter/material.dart';

class DistanceSelector extends StatefulWidget {
  const DistanceSelector(
      {Key? key, required this.initialDistance, required this.updateDistance})
      : super(key: key);

  final void Function(double) updateDistance;
  final double initialDistance;

  @override
  State<DistanceSelector> createState() => _DistanceSelectorState();
}

class _DistanceSelectorState extends State<DistanceSelector> {
  late double _distanceValue = widget.initialDistance;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
        data: SliderTheme.of(context).copyWith(
            activeTickMarkColor: Colors.transparent,
            inactiveTickMarkColor: Colors.transparent),
        child: Slider(
            value: _distanceValue,
            onChanged: (newDistance) {
              setState(() {
                _distanceValue = newDistance;
              });
              widget.updateDistance(newDistance);
            },
            divisions: 38,
            label: _distanceValue.toStringAsFixed(1),
            min: 1.0,
            max: 20.0));
  }
}
