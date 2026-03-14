import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

const positionTop = 0.15;
const positionMiddle = 0.5;
const positionBottom = 0.828;
const List<double> positionFactor = [
  positionTop,
  positionMiddle,
  positionBottom
];

const grabbingHeight = 22.0;

const Duration snappingDuration = Duration(seconds: 1);
const Curve snappingCurve = Curves.easeOutExpo;

List<SnappingPosition> getSnappingPositions() {
  return const [
    SnappingPosition.factor(
      positionFactor: positionTop,
      snappingCurve: snappingCurve,
      snappingDuration: snappingDuration,
      grabbingContentOffset: GrabbingContentOffset.top,
    ),
    SnappingPosition.factor(
      positionFactor: positionMiddle,
      snappingCurve: snappingCurve,
      snappingDuration: snappingDuration,
      grabbingContentOffset: GrabbingContentOffset.top,
    ),
    SnappingPosition.factor(
      positionFactor: positionBottom,
      snappingCurve: snappingCurve,
      snappingDuration: snappingDuration,
      grabbingContentOffset: GrabbingContentOffset.top,
    ),
  ];
}

final snappingSheetController = SnappingSheetController();

void snaptoInitPosition() {
  snappingSheetController.snapToPosition(
    const SnappingPosition.factor(positionFactor: 0.5),
  );
}

// void checkCurrentPosition(double screenHeight, SheetPositionData sheetPosition, SnappingPosition snappingPosition) {
//   double totalMovableHeight = screenHeight - grabbingHeight;
//   double positionFactor = sheetPosition.pixels / totalMovableHeight;
//   double closest = positionFactor.reduce((a, b) =>
//       (positionFactor - a).abs() < (positionFactor - b).abs() ? a : b);

//   print("Closest predefined position to current: $closest");
//   print("Current position factor: $positionFactor");
// }
