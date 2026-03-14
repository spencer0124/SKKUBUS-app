import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Injects client metadata headers that the server uses for observability.
///
/// Headers set:
/// - `Accept-Language` — device locale (ko, en, zh)
/// - `X-App-Version` — app version from pubspec (e.g. "3.3.0")
/// - `X-Platform` — "ios" or "android"
///
/// Values are resolved once on first request, then cached.
class PlatformInterceptor extends Interceptor {
  String? _cachedVersion;
  String? _cachedPlatform;
  String? _cachedLocale;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Resolve and cache on first call
    _cachedPlatform ??= Platform.isIOS ? 'ios' : 'android';

    if (_cachedVersion == null) {
      try {
        final info = await PackageInfo.fromPlatform();
        _cachedVersion = info.version;
      } catch (_) {
        _cachedVersion = 'unknown';
      }
    }

    _cachedLocale ??= _resolveLocale();

    options.headers['Accept-Language'] = _cachedLocale;
    options.headers['X-App-Version'] = _cachedVersion;
    options.headers['X-Platform'] = _cachedPlatform;

    handler.next(options);
  }

  /// Maps device locale to the server's supported language codes.
  /// Server supports: ko, en, zh (see lib/langMiddleware.js).
  String _resolveLocale() {
    final binding = WidgetsBinding.instance;
    final locale = binding.platformDispatcher.locale;
    return switch (locale.languageCode) {
      'ko' => 'ko',
      'zh' => 'zh',
      _ => 'en',
    };
  }
}
