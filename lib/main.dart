import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
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

import 'package:skkumap/core/routes/app_routes.dart';
import 'package:skkumap/features/app_shell/binding/app_shell_binding.dart';
import 'package:skkumap/features/app_shell/ui/app_shell_screen.dart';
import 'package:skkumap/firebase_options.dart';
import 'languages.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:skkumap/features/campus_map/ui/navermap/navermap_controller.dart';
import 'package:skkumap/core/utils/geolocator.dart';
import 'package:skkumap/core/utils/app_logger.dart';
import 'package:skkumap/core/utils/analytics_screen_names.dart';

import 'package:skkumap/core/data/api_client.dart' as data;
import 'package:skkumap/core/data/dio_client.dart';
import 'package:skkumap/features/transit/data/bus_repository.dart';
import 'package:skkumap/features/transit/data/bus_config_repository.dart';
import 'package:skkumap/features/campus_map/data/map_config_repository.dart';
import 'package:skkumap/features/campus_map/data/map_layer_repository.dart';
import 'package:skkumap/features/transit/data/station_repository.dart';
import 'package:skkumap/features/building/data/building_repository.dart';
import 'package:skkumap/features/building/controller/building_detail_controller.dart';
import 'package:skkumap/core/repositories/ad_repository.dart';
import 'package:skkumap/core/repositories/ui_repository.dart';
import 'package:skkumap/core/data/connectivity_service.dart';
import 'package:skkumap/core/services/analytics_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

const storage = FlutterSecureStorage();

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: SystemUiOverlay.values,
  );

  await initEnvironmentVariables();
  await initFirebase();
  registerDependencies();
  await Get.find<data.ApiClient>().ensureAuth();

  // ── Analytics: set user ID + initial properties ──
  if (!kDebugMode) {
    final analyticsService = Get.find<AnalyticsService>();
    analyticsService.setUserId(FirebaseAuth.instance.currentUser?.uid);
    analyticsService.setAppLanguage(Get.deviceLocale?.languageCode ?? 'ko');
    analyticsService.setPreferredCampus('hssc');
  }

  Get.find<MapConfigRepository>().initialize(); // fire-and-forget, non-blocking
  Get.put(ConnectivityService());
  await initMobileAds();
  await initNaverMapSdkV2();

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
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Get.find<MapConfigRepository>().checkForUpdates();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) => GetMaterialApp(
        navigatorObservers: [
          if (!kDebugMode)
            FirebaseAnalyticsObserver(
              analytics: analytics,
              nameExtractor: (settings) =>
                  analyticsNameExtractor(settings) ?? settings.name,
            ),
        ],
        debugShowCheckedModeBanner: false,
        getPages: AppRoutes.routes,
        initialRoute: Routes.splash,
        unknownRoute: GetPage(
          name: '/not-found',
          page: () => const Mainpage(),
          binding: AppShellBinding(),
        ),
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
  if (kDebugMode) {
    // Disable Analytics & Crashlytics in debug to keep production data clean
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
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

Future<void> initNaverMapSdkV2() async {
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
  // ── Analytics (registered first so controllers can depend on it) ──
  Get.put(AnalyticsService());

  // ── API infrastructure (fenix: true — survives controller dispose) ──
  final dio = createDioClient();
  final apiClient = data.ApiClient(dio);
  Get.put<data.ApiClient>(apiClient);

  Get.lazyPut(() => BusRepository(Get.find<data.ApiClient>()), fenix: true);
  Get.put(BusConfigRepository(Get.find<data.ApiClient>()));
  Get.lazyPut(() => StationRepository(Get.find<data.ApiClient>()), fenix: true);
  Get.lazyPut(() => BuildingRepository(Get.find<data.ApiClient>()), fenix: true);
  Get.lazyPut(() => AdRepository(Get.find<data.ApiClient>()), fenix: true);
  Get.lazyPut(() => UiRepository(Get.find<data.ApiClient>()), fenix: true);
  Get.put(MapConfigRepository(Get.find<data.ApiClient>()));
  Get.lazyPut(() => MapLayerRepository(Get.find<data.ApiClient>()), fenix: true);

  // ── App-global controllers (needed across all pages) ──
  Get.lazyPut(() => UltimateNMapController());
  Get.lazyPut(() => LocationController());
  Get.lazyPut(() => BuildingDetailController(), fenix: true);
}
