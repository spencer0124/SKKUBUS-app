import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:skkumap/app/model/campus_service_model.dart';
import 'package:skkumap/app/routes/app_routes.dart';

/// Unified action dispatcher for all SDUI components.
///
/// Handles route navigation, in-app webview, and external URL launching.
/// Used by button_grid items, banners, notices, and any future SDUI actions.
Future<void> handleSduiAction({
  required ActionType actionType,
  required String actionValue,
  String? webviewTitle,
  String? webviewColor,
}) async {
  switch (actionType) {
    case ActionType.route:
      Get.toNamed(actionValue);
    case ActionType.webview:
      Get.toNamed(Routes.webview, arguments: {
        'title': webviewTitle ?? '',
        'color': webviewColor ?? '003626',
        'webviewLink': actionValue,
      });
    case ActionType.external:
      final uri = Uri.parse(actionValue);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
  }
}
