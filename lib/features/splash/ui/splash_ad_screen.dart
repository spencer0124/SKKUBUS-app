import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skkumap/core/routes/app_routes.dart';
import 'package:skkumap/features/campus_map/data/map_config_repository.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';

class SplashAd extends StatefulWidget {
  const SplashAd({Key? key}) : super(key: key);

  @override
  State<SplashAd> createState() => _SplashAdState();
}

class _SplashAdState extends State<SplashAd> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await Get.find<MapConfigRepository>().ensureLoaded();
    FlutterNativeSplash.remove();
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.offNamed(Routes.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: Colors.white);
  }
}
