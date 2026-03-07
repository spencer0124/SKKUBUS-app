import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skkumap/app/utils/analytics_screen_names.dart';

void main() {
  group('analyticsNameExtractor', () {
    test('returns null for null route name', () {
      const settings = RouteSettings(name: null);
      expect(analyticsNameExtractor(settings), isNull);
    });

    test('maps known routes correctly', () {
      const cases = {
        '/splash': 'splash_screen',
        '/home': 'home_screen',
        '/bus/realtime': 'bus_realtime_screen',
        '/bus/campus': 'bus_campus_screen',
        '/alert': 'alert_screen',
        '/map/hssc': 'map_hssc_screen',
        '/map/hssc/credit': 'map_hssc_credit_screen',
        '/map/nsc': 'map_nsc_screen',
        '/map/nsc/credit': 'map_nsc_credit_screen',
        '/lost-and-found': 'lost_and_found_screen',
        '/search': 'search_screen',
      };

      for (final entry in cases.entries) {
        final settings = RouteSettings(name: entry.key);
        expect(
          analyticsNameExtractor(settings),
          entry.value,
          reason: 'Route ${entry.key} should map to ${entry.value}',
        );
      }
    });

    test('webview with screenName argument returns webview_{id}_screen', () {
      const settings = RouteSettings(
        name: '/webview',
        arguments: {'screenName': 'jongro07'},
      );
      expect(analyticsNameExtractor(settings), 'webview_jongro07_screen');
    });

    test('webview with empty screenName falls back to webview_screen', () {
      const settings = RouteSettings(
        name: '/webview',
        arguments: {'screenName': ''},
      );
      expect(analyticsNameExtractor(settings), 'webview_screen');
    });

    test('webview without screenName argument falls back to webview_screen',
        () {
      const settings = RouteSettings(
        name: '/webview',
        arguments: {'title': 'Some Title'},
      );
      expect(analyticsNameExtractor(settings), 'webview_screen');
    });

    test('webview without arguments falls back to webview_screen', () {
      const settings = RouteSettings(name: '/webview');
      expect(analyticsNameExtractor(settings), 'webview_screen');
    });

    test('webview with non-Map arguments falls back to webview_screen', () {
      const settings = RouteSettings(name: '/webview', arguments: 'string');
      expect(analyticsNameExtractor(settings), 'webview_screen');
    });
  });
}
