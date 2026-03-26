import 'package:get/get.dart';

import 'package:skkumap/features/transit/binding/bus_campus_binding.dart';
import 'package:skkumap/features/transit/ui/bus_campus_screen.dart';
import 'package:skkumap/features/transit/binding/bus_realtime_binding.dart';
import 'package:skkumap/features/transit/ui/bus_realtime_screen.dart';
import 'package:skkumap/features/building_map/hssc/binding/hssc_building_map_binding.dart';
import 'package:skkumap/features/building_map/hssc/ui/hssc_building_map_screen.dart';
import 'package:skkumap/features/building_map/hssc/ui/hssc_building_credit.dart';
import 'package:skkumap/features/app_shell/binding/app_shell_binding.dart';
import 'package:skkumap/features/app_shell/ui/app_shell_screen.dart';
import 'package:skkumap/features/alert/ui/alert_screen.dart';
import 'package:skkumap/features/building_map/nsc/binding/nsc_building_map_binding.dart';
import 'package:skkumap/features/building_map/nsc/ui/nsc_building_map_screen.dart';
import 'package:skkumap/features/building_map/nsc/ui/nsc_building_credit.dart';
import 'package:skkumap/features/webview/binding/webview_binding.dart';
import 'package:skkumap/features/webview/ui/webview_screen.dart';
import 'package:skkumap/features/search/binding/search_binding.dart';
import 'package:skkumap/features/search/ui/search_screen.dart';
import 'package:skkumap/features/splash/ui/splash_ad_screen.dart';
import 'package:skkumap/features/dev/sds_button_test_screen.dart';

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
  static const devButtonTest = '/dev/button-test';
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
      binding: AppShellBinding(),
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
      page: () => const CustomWebViewScreen(),
      binding: WebViewBinding(),
    ),
    GetPage(
      name: Routes.search,
      page: () => const SearchScreen(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: Routes.devButtonTest,
      page: () => const SdsButtonTestScreen(),
    ),
  ];
}
