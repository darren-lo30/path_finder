import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class TravelModeSelector extends StatelessWidget {
  TravelModeSelector(
      {Key? key, required this.updateTravelMode, required this.travelMode})
      : super(key: key);

  final void Function(TravelMode) updateTravelMode;
  final TravelMode travelMode;

  final List<TravelMode> _travelModes = [
    TravelMode.walking,
    TravelMode.bicycling,
    TravelMode.driving
  ];

  late final List<bool> _selections =
      _travelModes.map((TravelMode mode) => mode == travelMode).toList();

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      onPressed: (int index) {
        // Invoke call back to update the set mode
        updateTravelMode(_travelModes[index]);
      },
      isSelected: _selections,
      children: const <Widget>[
        Icon(Icons.directions_walk_rounded),
        Icon(Icons.directions_bike_rounded),
        Icon(Icons.directions_car_rounded),
      ],
    );
  }
}
