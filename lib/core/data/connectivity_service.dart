import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

/// Reactive network state monitor.
///
/// Exposes [isOnline] as an observable so controllers and widgets can
/// react to connectivity changes. Shows a snackbar on offline transitions
/// with debounce protection against flicker (subway, tunnels, etc.).
class ConnectivityService extends GetxService {
  final _isOnline = true.obs;
  bool get isOnline => _isOnline.value;

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// Minimum interval between offline snackbar displays.
  /// Prevents rapid flicker in unstable networks (e.g. subway transitions).
  static const _snackbarCooldown = Duration(seconds: 3);
  DateTime _lastSnackbarTime = DateTime(2000);

  @override
  void onInit() {
    super.onInit();
    _subscription = Connectivity().onConnectivityChanged.listen(_onChanged);
  }

  void _onChanged(List<ConnectivityResult> results) {
    final online = results.any((r) => r != ConnectivityResult.none);
    final wasOnline = _isOnline.value;
    _isOnline.value = online;

    if (wasOnline && !online) {
      final now = DateTime.now();
      if (now.difference(_lastSnackbarTime) > _snackbarCooldown) {
        _lastSnackbarTime = now;
        Get.rawSnackbar(
          message: '네트워크 연결이 불안정합니다',
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
        );
      }
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
