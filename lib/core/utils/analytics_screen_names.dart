import 'package:flutter/widgets.dart';

String? analyticsNameExtractor(RouteSettings settings) {
  final routeName = settings.name;
  if (routeName == null) return null;

  const screenNames = <String, String>{
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

  if (screenNames.containsKey(routeName)) {
    return screenNames[routeName];
  }

  // WebView: busConfig.id 기반 screenName (locale-independent)
  if (routeName == '/webview') {
    final args = settings.arguments;
    if (args is Map<String, dynamic>) {
      final screenName = args['screenName'] as String?;
      if (screenName != null && screenName.isNotEmpty) {
        return 'webview_${screenName}_screen';
      }
    }
    return 'webview_screen';
  }

  assert(false, 'Route "$routeName" not mapped in analyticsNameExtractor');
  return routeName;
}
