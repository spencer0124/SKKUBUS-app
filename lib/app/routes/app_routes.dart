import 'package:get/get.dart';
import 'package:skkumap/app/pages/KingoInfo/binding/kingoinfo_binding.dart';
import 'package:skkumap/app/pages/KingoInfo/ui/kingoinfo_view.dart';
import 'package:skkumap/app/pages/KingoLogin/binding/kingoLogin_binding.dart';
import 'package:skkumap/app/pages/KingoLogin/ui/KingoLogin_view.dart';

import 'package:skkumap/app/pages/bus_inja_main/binding/bus_inja_main_binding.dart';

import 'package:skkumap/app/pages/hssc_building_map/binding/hssc_building_map_binding.dart';
import 'package:skkumap/app/pages/hssc_building_map/ui/hssc_building_map_screen.dart';
import 'package:skkumap/app/pages/bus_main_main/binding/bus_seoul_main_binding.dart';
import 'package:skkumap/app/pages/bus_main_main/ui/bus_seoul_main_screen.dart';

import 'package:skkumap/app/pages/bus_inja_main/ui/bus_inja_main_screen.dart';
import 'package:skkumap/app/pages/mainpage/binding/mainpage_binding.dart';
import 'package:skkumap/app/pages/mainpage/ui/mainpage_screen.dart';

import 'package:skkumap/app/pages/new_alert/ui/new_alert.dart';
import 'package:skkumap/app/pages/hssc_building_credit/ui/hssc_building_credit.dart';
import 'package:skkumap/app/pages/webview/binding/webview_binding.dart';
import 'package:skkumap/app/pages/webview/ui/webview_screen.dart';
import 'package:skkumap/app/pages/nsc_building_map/binding/nsc_building_map_binding.dart';
import 'package:skkumap/app/pages/nsc_building_map/ui/nsc_building_map_screen.dart';
import 'package:skkumap/app/pages/nsc_building_credit/ui/nsc_building_credit.dart';
import 'package:skkumap/app/pages/lostandfound/ui/lostandfound.dart';
import 'package:skkumap/app/pages/search_list/binding/search_list_binding.dart';
import 'package:skkumap/app/pages/search_list/ui/search_list_screen.dart';
import 'package:skkumap/app/pages/splash_ad/ui/splash_ad_screen.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/',
      page: () => const SplashAd(),
    ),
    GetPage(
      name: '/MainbusMain',
      page: () => const BusDataScreen(),
      binding: BusDataBinding(),
    ),
    GetPage(
      name: '/eskara',
      page: () => const ESKARA(),
      binding: ESKARABinding(),
    ),
    GetPage(
      name: '/newalert',
      page: () => const NewAlert(),
    ),
    GetPage(
      name: '/mainpage',
      page: () => const Mainpage(),
      binding: MainpageBinding(),
    ),
    GetPage(
      name: '/kingologin',
      page: () => const KingoLoginView(),
      binding: KingoLoginBinding(),
    ),
    GetPage(
      name: '/kingoinfo',
      page: () => const KingoInfoView(),
      binding: KingoInfoBinding(),
    ),
    GetPage(
      name: '/hsscbuildingmap',
      page: () => const HSSCBuildingMap(),
      binding: HSSCBuildingMapBinding(),
    ),
    GetPage(
      name: '/hsscbuildingcredit',
      page: () => const HSSCBuildingCredit(),
    ),
    GetPage(
      name: '/nscbuildingmap',
      page: () => const NSCBuildingMap(),
      binding: NSCBuildingMapBinding(),
    ),
    GetPage(
      name: '/nscbuildingcredit',
      page: () => const NSCBuildingCredit(),
    ),
    GetPage(
      name: '/customwebview',
      page: () => const CustomWebViewScreen(),
      binding: WebViewBinding(),
    ),
    GetPage(
      name: '/lostandfound',
      page: () => const LostAndFound(),
    ),
    GetPage(
      name: '/searchlist',
      page: () => const SearchList(),
      binding: SearchListBinding(),
    ),
    GetPage(
      name: '/splashad',
      page: () => const SplashAd(),
    ),
  ];
}
