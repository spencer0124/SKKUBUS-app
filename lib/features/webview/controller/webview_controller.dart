import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomWebViewController extends GetxController {
  late WebViewController webcontroller;

  void initializeWebView(String webviewLink) {
    webcontroller =
        WebViewController()
          ..clearCache()
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (NavigationRequest request) {
                final Uri uri = Uri.parse(request.url);

                if (!request.isMainFrame &&
                    (uri.scheme == 'http' || uri.scheme == 'https')) {
                  if (!uri.host.contains('oopy.io')) {
                    launchUrl(uri);
                    return NavigationDecision.prevent;
                  }
                }

                return NavigationDecision.navigate;
              },
            ),
          )
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..addJavaScriptChannel(
            'customwebviewmessage',
            onMessageReceived: (JavaScriptMessage message) async {
              if (await canLaunchUrl(Uri.parse(message.message)) == true) {
                launchUrl(Uri.parse(message.message));
              }
            },
          )
          ..loadRequest(Uri.parse(webviewLink));
  }

}
