import 'package:skkumap/app/model/campus_service_model.dart';
import 'package:skkumap/app/model/sdui_section.dart';

final defaultCampusSections = <SduiSection>[
  const SduiButtonGrid(
    id: 'default_grid',
    columns: 4,
    items: [
      SduiButtonItem(
        id: 'building_map',
        title: '건물지도',
        emoji: '\u{1F3E2}',
        actionType: ActionType.route,
        actionValue: '/map/hssc',
      ),
      SduiButtonItem(
        id: 'building_code',
        title: '건물코드',
        emoji: '\u{1F522}',
        actionType: ActionType.route,
        actionValue: '/search',
      ),
      SduiButtonItem(
        id: 'lost_found',
        title: '분실물',
        emoji: '\u{1F9F3}',
        actionType: ActionType.webview,
        actionValue: 'https://webview.skkuuniverse.com/#/skku/lostandfound',
        webviewTitle: '분실물',
        webviewColor: '003626',
      ),
      SduiButtonItem(
        id: 'inquiry',
        title: '문의하기',
        emoji: '\u{1F4AC}',
        actionType: ActionType.external,
        actionValue: 'http://pf.kakao.com/_cjxexdG/chat',
      ),
    ],
  ),
];
