import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

// class CustomWebViewController extends GetxController {
//   var webcontroller = WebViewController()
//     ..clearCache()
//     ..setJavaScriptMode(JavaScriptMode.unrestricted)
//     ..setBackgroundColor(const Color(0x00000000))
//     ..addJavaScriptChannel(
//       'customwebviewmessage',
//       // 'knewyearmessage',
//       onMessageReceived: (JavaScriptMessage message) async {
//         // print("clicked");
//         if (await canLaunchUrl(Uri.parse(message.message)) == true) {
//           launchUrl(Uri.parse(message.message));
//         }
//         // print(message.message);
//       },
//     )
//     ..loadRequest(Uri.parse(
//         "https://spencer0124.github.io/SKKUBUS_webview/#/bus/newyear"));
// }

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

                // 1. 핵심 수정 사항: isMainFrame이 아니면서 'http/https' 프로토콜을 사용하는 요청인지 확인
                // 이렇게 하면 키보드 입력 시 발생하는 'about:blank'와 같은 내부 요청을 걸러낼 수 있습니다.
                if (!request.isMainFrame &&
                    (uri.scheme == 'http' || uri.scheme == 'https')) {
                  // 2. 기존 로직 유지: oopy.io가 아닌 외부 링크일 때만 외부 브라우저 실행
                  if (!uri.host.contains('oopy.io')) {
                    // launchUrl 함수는 비동기이므로 await를 사용하거나 반환값을 처리하지 않아도 됩니다.
                    launchUrl(uri);

                    // 웹뷰 내에서는 해당 URL로 이동하지 않도록 방지합니다.
                    return NavigationDecision.prevent;
                  }
                }

                // 3. 그 외 모든 경우 (일반적인 페이지 이동, 키보드 관련 내부 동작 등)
                // 웹뷰가 내부적으로 처리하도록 허용합니다.
                return NavigationDecision.navigate;
              },
            ),
          )
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..addJavaScriptChannel(
            'customwebviewmessage',
            // 'knewyearmessage',
            onMessageReceived: (JavaScriptMessage message) async {
              // print("clicked");
              if (await canLaunchUrl(Uri.parse(message.message)) == true) {
                launchUrl(Uri.parse(message.message));
              }
              // print(message.message);
            },
          )
          ..loadRequest(Uri.parse(webviewLink));
  }
}
