import 'package:get/get.dart';

import 'package:skkumap/app/pages/bus_campus/binding/bus_campus_binding.dart';
import 'package:skkumap/app/pages/bus_campus/ui/bus_campus_screen.dart';
import 'package:skkumap/app/pages/bus_realtime/binding/bus_realtime_binding.dart';
import 'package:skkumap/app/pages/bus_realtime/ui/bus_realtime_screen.dart';
import 'package:skkumap/app/pages/hssc_building_map/binding/hssc_building_map_binding.dart';
import 'package:skkumap/app/pages/hssc_building_map/ui/hssc_building_map_screen.dart';
import 'package:skkumap/app/pages/hssc_building_credit/ui/hssc_building_credit.dart';
import 'package:skkumap/app/pages/mainpage/binding/mainpage_binding.dart';
import 'package:skkumap/app/pages/mainpage/ui/mainpage_screen.dart';
import 'package:skkumap/app/pages/alert/ui/alert_screen.dart';
import 'package:skkumap/app/pages/nsc_building_map/binding/nsc_building_map_binding.dart';
import 'package:skkumap/app/pages/nsc_building_map/ui/nsc_building_map_screen.dart';
import 'package:skkumap/app/pages/nsc_building_credit/ui/nsc_building_credit.dart';
import 'package:skkumap/app/pages/webview/binding/webview_binding.dart';
import 'package:skkumap/app/pages/webview/ui/webview_screen.dart';
import 'package:skkumap/app/pages/lost_and_found/ui/lostandfound.dart';
import 'package:skkumap/app/pages/search/binding/search_binding.dart';
import 'package:skkumap/app/pages/search/ui/search_screen.dart';
import 'package:skkumap/app/pages/splash_ad/ui/splash_ad_screen.dart';

abstract class Routes {
  static const splash = '/splash';
  static const home = '/home';
  static const busRealtime = '/bus/realtime';
  static const busCampus = '/bus/campus';
  static const alert = '/alert';
  static const mapHssc = '/map/hssc';
  static const mapHsscCredit = '/map/hssc/credit';
  static const mapNsc = '/map/nsc';
  static const mapNscCredit = '/map/nsc/credit';
  static const webview = '/webview';
  static const lostAndFound = '/lost-and-found';
  static const search = '/search';
}

class AppRoutes {
  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashAd(),
    ),
    GetPage(
      name: Routes.busRealtime,
      page: () => const BusRealtimeScreen(),
      binding: BusRealtimeBinding(),
    ),
    GetPage(
      name: Routes.busCampus,
      page: () => const BusCampusScreen(),
      binding: BusCampusBinding(),
    ),
    GetPage(
      name: Routes.alert,
      page: () => const AlertScreen(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const Mainpage(),
      binding: MainpageBinding(),
    ),
    GetPage(
      name: Routes.mapHssc,
      page: () => const HSSCBuildingMap(),
      binding: HSSCBuildingMapBinding(),
    ),
    GetPage(
      name: Routes.mapHsscCredit,
      page: () => const HSSCBuildingCredit(),
    ),
    GetPage(
      name: Routes.mapNsc,
      page: () => const NSCBuildingMap(),
      binding: NSCBuildingMapBinding(),
    ),
    GetPage(
      name: Routes.mapNscCredit,
      page: () => const NSCBuildingCredit(),
    ),
    GetPage(
      name: Routes.webview,
      page: () => const CustomWebViewScreen(),
      binding: WebViewBinding(),
    ),
    GetPage(
      name: Routes.lostAndFound,
      page: () => const LostAndFound(),
    ),
    GetPage(
      name: Routes.search,
      page: () => const SearchScreen(),
      binding: SearchBinding(),
    ),
  ];
}
