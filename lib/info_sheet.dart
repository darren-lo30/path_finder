import 'package:flutter/material.dart';
import 'package:walk_finder/mode_selector.dart';
import 'package:walk_finder/options.dart';

class InfoSheet extends StatefulWidget {
  const InfoSheet({
    Key? key,
    required this.updateTransportationMode,
  }) : super(key: key);

  final void Function(TransportationMode mode) updateTransportationMode;

  @override
  State<InfoSheet> createState() => _InfoBarState();
}

class _InfoBarState extends State<InfoSheet> {
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
                    builder: (BuildContext context) {
                      return Container(
                          height: 200,
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              ModeSelector(
                                  updateTransportationMode:
                                      widget.updateTransportationMode),
                            ],
                          ));
                    });
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all(const CircleBorder()),
                padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
              ),
              child: const Icon(Icons.keyboard_arrow_up_rounded,
                  color: Colors.black),
            )));
  }
}
