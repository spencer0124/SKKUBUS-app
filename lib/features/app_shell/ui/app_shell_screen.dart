import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:skkumap/features/app_shell/controller/app_shell_controller.dart';
import 'package:skkumap/features/campus_map/ui/campus_map_tab.dart';
import 'package:skkumap/features/transit/ui/transit_tab.dart';
import 'package:skkumap/features/app_shell/widgets/bottom_navigation.dart';

class Mainpage extends GetView<AppShellController> {
  const Mainpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size(0, 0),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Obx(() => _LazyIndexedStack(
                index: controller.bottomNavigationIndex.value - 1,
                builders: [
                  () => const CampusMapTab(),
                  () => const TransitTab(),
                ],
              )),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Obx(
              () => Bottomnavigation(
                index: controller.bottomNavigationIndex.value,
                onItemTapped: (int index) {
                  controller.bottomNavigationIndex.value = index;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LazyIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget Function()> builders;

  const _LazyIndexedStack({
    required this.index,
    required this.builders,
  });

  @override
  State<_LazyIndexedStack> createState() => _LazyIndexedStackState();
}

class _LazyIndexedStackState extends State<_LazyIndexedStack> {
  late final List<bool> _activated;
  late final List<Widget?> _children;

  @override
  void initState() {
    super.initState();
    _activated = List.filled(widget.builders.length, false);
    _children = List.filled(widget.builders.length, null);
    // Eagerly build all tabs so NaverMap initializes immediately
    for (int i = 0; i < widget.builders.length; i++) {
      _activateIndex(i);
    }
  }

  @override
  void didUpdateWidget(covariant _LazyIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    _activateIndex(widget.index);
  }

  void _activateIndex(int index) {
    if (index >= 0 && index < _activated.length && !_activated[index]) {
      _activated[index] = true;
      _children[index] = widget.builders[index]();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      sizing: StackFit.expand,
      index: widget.index,
      children: [
        for (int i = 0; i < widget.builders.length; i++)
          _children[i] ?? const SizedBox.shrink(),
      ],
    );
  }
}
