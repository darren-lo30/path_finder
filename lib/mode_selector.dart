import 'package:flutter/material.dart';
import 'package:walk_finder/options.dart';

class ModeSelector extends StatefulWidget {
  final void Function(TransportationMode) updateTransportationMode;
  const ModeSelector({Key? key, required this.updateTransportationMode})
      : super(key: key);

  @override
  State<ModeSelector> createState() => _ModeSelectorState();
}

class _ModeSelectorState extends State<ModeSelector> {
  final List<bool> _selections = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      onPressed: (int index) {
        // Invoke call back to update the set mode
        widget.updateTransportationMode(TransportationMode.values[index]);

        // Select the toggle button clicked and unselect everything else
        for (int i = 0; i < _selections.length; i++) {
          if (i == index) {
            _selections[i] = true;
          } else {
            _selections[i] = false;
          }
        }
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
