import 'package:get/get.dart';

import 'package:skkumap/app/pages/bus_campus/binding/bus_inja_main_binding.dart';
import 'package:skkumap/app/pages/bus_campus/ui/bus_inja_main_screen.dart';
import 'package:skkumap/app/pages/bus_hssc/binding/bus_seoul_main_binding.dart';
import 'package:skkumap/app/pages/bus_hssc/ui/bus_seoul_main_screen.dart';
import 'package:skkumap/app/pages/hssc_building_map/binding/hssc_building_map_binding.dart';
import 'package:skkumap/app/pages/hssc_building_map/ui/hssc_building_map_screen.dart';
import 'package:skkumap/app/pages/hssc_building_credit/ui/hssc_building_credit.dart';
import 'package:skkumap/app/pages/mainpage/binding/mainpage_binding.dart';
import 'package:skkumap/app/pages/mainpage/ui/mainpage_screen.dart';
import 'package:skkumap/app/pages/alert/ui/new_alert.dart';
import 'package:skkumap/app/pages/nsc_building_map/binding/nsc_building_map_binding.dart';
import 'package:skkumap/app/pages/nsc_building_map/ui/nsc_building_map_screen.dart';
import 'package:skkumap/app/pages/nsc_building_credit/ui/nsc_building_credit.dart';
import 'package:skkumap/app/pages/webview/binding/webview_binding.dart';
import 'package:skkumap/app/pages/webview/ui/webview_screen.dart';
import 'package:skkumap/app/pages/lost_and_found/ui/lostandfound.dart';
import 'package:skkumap/app/pages/search_list/binding/search_list_binding.dart';
import 'package:skkumap/app/pages/search_list/ui/search_list_screen.dart';
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
      page: () => const BusDataScreen(),
      binding: BusDataBinding(),
    ),
    GetPage(
      name: Routes.busCampus,
      page: () => const ESKARA(),
      binding: ESKARABinding(),
    ),
    GetPage(
      name: Routes.alert,
      page: () => const NewAlert(),
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
      page: () => const SearchList(),
      binding: SearchListBinding(),
    ),
  ];
}
