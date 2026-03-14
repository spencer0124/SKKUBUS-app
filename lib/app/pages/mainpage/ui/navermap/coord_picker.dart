import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';

class CoordPickerController extends GetxController {
  final points = <NLatLng>[].obs;
  final enabled = false.obs;

  void addPoint(NLatLng latLng) {
    if (!enabled.value) return;
    points.add(latLng);
    dev.log('[${points.length - 1}] [${latLng.longitude}, ${latLng.latitude}]',
        name: 'CoordPicker');
  }

  void undoLast() {
    if (points.isNotEmpty) points.removeLast();
  }

  void clearAll() => points.clear();

  Set<NMarker> get markers => points.asMap().entries.map((e) {
        final m = NMarker(
          id: '_pick_${e.key}',
          position: e.value,
          size: const Size(12, 12),
          iconTintColor: Colors.red,
        );
        m.setCaption(NOverlayCaption(text: '${e.key}', textSize: 10));
        return m;
      }).toSet();

  void printAll() {
    final coords = points
        .map((p) => '  [${p.longitude}, ${p.latitude}]')
        .join(',\n');
    dev.log('[\n$coords\n]', name: 'CoordPicker');
  }
}

class CoordPickerPanel extends GetView<CoordPickerController> {
  const CoordPickerPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.enabled.value) {
        return Positioned(
          bottom: 200,
          right: 10,
          child: _fab(
            icon: Icons.pin_drop_outlined,
            color: Colors.grey,
            onTap: () => controller.enabled.value = true,
          ),
        );
      }

      return Positioned(
        bottom: 200,
        right: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Point count badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${controller.points.length} pts',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 6),
            _fab(
              icon: Icons.print,
              color: Colors.blue,
              onTap: controller.points.isEmpty ? null : controller.printAll,
            ),
            const SizedBox(height: 6),
            _fab(
              icon: Icons.undo,
              color: Colors.orange,
              onTap: controller.points.isEmpty ? null : controller.undoLast,
            ),
            const SizedBox(height: 6),
            _fab(
              icon: Icons.delete_outline,
              color: Colors.red,
              onTap: controller.points.isEmpty ? null : controller.clearAll,
            ),
            const SizedBox(height: 6),
            _fab(
              icon: Icons.close,
              color: Colors.grey,
              onTap: () => controller.enabled.value = false,
            ),
          ],
        ),
      );
    });
  }

  Widget _fab({
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    final disabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: disabled ? Colors.grey.shade300 : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: disabled ? Colors.grey : color, size: 20),
      ),
    );
  }
}
