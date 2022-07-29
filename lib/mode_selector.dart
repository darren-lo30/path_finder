import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class ModeSelector extends StatefulWidget {
  final void Function(TravelMode) updateTravelMode;
  const ModeSelector(
      {Key? key,
      required this.updateTravelMode,
      required this.initialTravelMode})
      : super(key: key);

  final TravelMode initialTravelMode;

  @override
  State<ModeSelector> createState() => _ModeSelectorState();
}

class _ModeSelectorState extends State<ModeSelector> {
  final List<TravelMode> _travelModes = [
    TravelMode.walking,
    TravelMode.bicycling,
    TravelMode.driving
  ];

  late final List<bool> _selections = _travelModes
      .map((TravelMode mode) => mode == widget.initialTravelMode)
      .toList();

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      onPressed: (int index) {
        // Invoke call back to update the set mode
        widget.updateTravelMode(_travelModes[index]);

        // Select the toggle button clicked and unselect everything else
        setState(() {
          for (int i = 0; i < _selections.length; i++) {
            if (i == index) {
              _selections[i] = true;
            } else {
              _selections[i] = false;
            }
          }
        });
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
