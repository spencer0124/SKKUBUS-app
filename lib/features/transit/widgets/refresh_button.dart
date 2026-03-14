import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:skkumap/core/utils/app_logger.dart';

class RefreshButton extends StatefulWidget {
  final Color themeColor;
  final VoidCallback onRefresh;

  const RefreshButton({
    Key? key,
    required this.themeColor,
    required this.onRefresh,
  }) : super(key: key);

  @override
  State<RefreshButton> createState() => _RefreshButtonState();
}

class _RefreshButtonState extends State<RefreshButton>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    // Set the timer to refresh every 15 seconds
    _timer = Timer.periodic(const Duration(seconds: 15), (Timer t) {
      refreshAction();
    });
  }

  void refreshAction() async {
    logger.d('refresh action!');
    _controller
      ..reset()
      ..forward();
  }

  void resetTimer() {
    _timer.cancel();
    _timer = Timer.periodic(const Duration(seconds: 15), (Timer t) {
      refreshAction();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        resetTimer();
        refreshAction();
        widget.onRefresh();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 2,
            ),
            width: 35,
            height: 35,
            child: Lottie.asset(
              'assets/lottie/refresh.json',
              controller: _controller,
              onLoaded: (composition) {
                _controller
                  ..duration = composition.duration
                  ..forward();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }
}
