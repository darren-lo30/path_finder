import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:walk_finder/distance_selector.dart';
import 'package:walk_finder/mode_selector.dart';

class InfoSheet extends StatefulWidget {
  const InfoSheet(
      {Key? key,
      required this.updateTravelMode,
      required this.updateRoute,
      required this.updateDistance,
      required this.distance,
      required this.travelMode})
      : super(key: key);

  final void Function(TravelMode) updateTravelMode;
  final void Function(double) updateDistance;
  final VoidCallback updateRoute;

  final ValueNotifier<double> distance;
  final ValueNotifier<TravelMode> travelMode;

  @override
  State<InfoSheet> createState() => _InfoBarState();
}

class _InfoBarState extends State<InfoSheet> {
  void onFindRoutePressed() {
    Navigator.pop(context);
    widget.updateRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            margin: const EdgeInsets.only(bottom: 30.0),
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext buildContext) {
                      return Container(
                          height: 200,
                          color: Colors.white,
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[
                              ValueListenableBuilder(
                                  valueListenable: widget.travelMode,
                                  builder: (context, value, child) =>
                                      TravelModeSelector(
                                        updateTravelMode:
                                            widget.updateTravelMode,
                                        travelMode: widget.travelMode.value,
                                      )),
                              ValueListenableBuilder<double>(
                                  valueListenable: widget.distance,
                                  builder: (context, value, child) =>
                                      DistanceSelector(
                                        updateDistance: widget.updateDistance,
                                        distance: widget.distance.value,
                                      )),
                              TextButton(
                                  onPressed: onFindRoutePressed,
                                  child: const Text('Find Route'))
                            ],
                          ));
                    });
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all(const CircleBorder()),
                padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
              ),
              child: const Icon(Icons.keyboard_arrow_up_rounded,
                  color: Colors.white),
            )));
  }
}
