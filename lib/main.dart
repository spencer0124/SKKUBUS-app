import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:skkumap/app/pages/KingoLogin/controller/KingoLogin_controller.dart';
import 'package:skkumap/app/pages/bus_inja_detail/controller/bus_inja_detail_controller.dart';
import 'package:skkumap/app/pages/bus_inja_main/controller/bus_inja_main_controller.dart';
import 'package:skkumap/app/pages/hssc_building_map/controller/hssc_building_map_controller.dart';
import 'package:skkumap/app/pages/bus_main_detail/controller/bus_seoul_detail_controller.dart';
import 'package:skkumap/app/pages/bus_main_main/controller/bus_seoul_main_controller.dart';
import 'package:skkumap/app/pages/mainpage/controller/mainpage_controller.dart';
import 'package:skkumap/app/pages/webview/controller/webview_controller.dart';
import 'package:skkumap/app/routes/app_routes.dart';
import 'package:skkumap/firebase_options.dart';
import 'languages.dart';
import 'package:skkumap/app/pages/nsc_building_map/controller/nsc_building_map_controller.dart';
import 'package:skkumap/app/pages/search_list/controller/search_list_controller.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:skkumap/app/pages/mainpage/ui/navermap/navermap_controller.dart';
import 'package:skkumap/app/utils/geolocator.dart';
import 'package:skkumap/app/utils/app_logger.dart';

const storage = FlutterSecureStorage();

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: SystemUiOverlay.values,
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initEnvironmentVariables();
  registerDependencies();
  await initFirebase();
  await initMobileAds();
  await initNaverMapSdk_v2();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) => GetMaterialApp(
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
        debugShowCheckedModeBanner: false,
        getPages: AppRoutes.routes,
        initialRoute: '/',
        translations: Languages(),
        locale: Get.deviceLocale,
        fallbackLocale: const Locale('en', 'US'),
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
        ),
      ),
    );
  }
}

Future<void> initFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (!kDebugMode) {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
}

Future<void> initMobileAds() async {
  await MobileAds.instance.initialize();
}

Future<void> initEnvironmentVariables() async {
  await dotenv.load(fileName: ".env");
}

Future<void> initNaverMapSdk_v2() async {
  await FlutterNaverMap().init(
      clientId: dotenv.env['navernewClientId']!,
      onAuthFailed: (ex) {
        switch (ex) {
          case NQuotaExceededException(:final message):
            logger.w("사용량 초과 (message: $message)");
            break;
          case NUnauthorizedClientException() ||
                NClientUnspecifiedException() ||
                NAnotherAuthFailedException():
            logger.e("인증 실패: $ex");
            break;
        }
      });
}

void registerDependencies() {
  Get.lazyPut(() => BusDataController());
  Get.lazyPut(() => SeoulMainLifeCycle());

  Get.lazyPut(() => SeoulDetailController());
  Get.lazyPut(() => SeoulDetailLifeCycle());

  Get.lazyPut(() => InjaMainController());
  Get.lazyPut(() => InjaMainLifeCycle());

  Get.put(InjaDetailController());
  Get.put(InjaDetailLifeCycle());

  Get.lazyPut(() => MainpageController());
  Get.lazyPut(() => MainpageLifeCycle());

  Get.lazyPut(() => KingoLoginController());
  Get.lazyPut(() => KingoLoginLifeCycle());

  Get.put(HSSCBuildingMapController());
  Get.put(CustomWebViewController());
  Get.put(NSCBuildingMapController());
  Get.put(SearchListController());

  Get.lazyPut(() => UltimateNMapController());
  Get.lazyPut(() => LocationController());
}
