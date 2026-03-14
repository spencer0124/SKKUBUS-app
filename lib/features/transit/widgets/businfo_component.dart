import 'dart:async';
import 'package:flutter/material.dart';
import 'licenseplate.dart';
import 'pulse_animation.dart';
import 'package:skkumap/core/utils/constants.dart';

class BusInfoComponent extends StatefulWidget {
  final int elapsedSeconds;
  final int currentStationIndex;
  final int lastStationIndex;
  final String plateNumber;
  final Color themeColor;
  final Function onDataUpdated;

  const BusInfoComponent({
    Key? key,
    required this.elapsedSeconds,
    required this.currentStationIndex,
    required this.lastStationIndex,
    required this.plateNumber,
    required this.themeColor,
    required this.onDataUpdated,
  }) : super(key: key);

  @override
  State<BusInfoComponent> createState() => _BusInfoComponentState();
}

class _BusInfoComponentState extends State<BusInfoComponent> {
  late int elapsedSecondsOverride;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    elapsedSecondsOverride = widget
        .elapsedSeconds; // Start with the initial elapsed seconds passed in.
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsedSecondsOverride++; // Increment the elapsed seconds.
      });
    });
  }

  void updateElapsedSeconds() {
    setState(() {
      elapsedSecondsOverride = widget.elapsedSeconds;
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Don't forget to cancel the timer.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.onDataUpdated(updateElapsedSeconds);

    return Positioned(
      top: widget.currentStationIndex >= widget.lastStationIndex
          ? 26 + 66.0 * widget.currentStationIndex
          : elapsedSecondsOverride > 200
              ? 26 + 66.0 * widget.currentStationIndex + 40
              : 26 +
                  66.0 * widget.currentStationIndex +
                  elapsedSecondsOverride / 5,
      left: BusConstants.infoComponentLeftpadding,
      child: Row(
        children: [
          LicensePlate(
            plateNumber: widget.plateNumber,
          ),
          const SizedBox(
            width: 5,
          ),
          PulseAnimation(
            themeColor: widget.themeColor,
          ),
        ],
      ),
    );
  }
}
