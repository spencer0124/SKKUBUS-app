import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum CustomNavigationBtnType { close, info, help }

class CustomNavigationBar extends StatelessWidget {
  final String title;
  final bool isDisplayLeftBtn;
  final bool isDisplayRightBtn;
  final VoidCallback leftBtnAction;
  final VoidCallback rightBtnAction;
  final CustomNavigationBtnType rightBtnType;

  static const _textColor = Color(0xFF191F28);
  static const _rightTextColor = Color(0xFF6B7684);
  static const _dividerColor = Color(0xFFF2F4F6);

  const CustomNavigationBar({
    super.key,
    this.title = 'loading',
    this.isDisplayLeftBtn = true,
    this.isDisplayRightBtn = true,
    this.leftBtnAction = _defaultFunction,
    this.rightBtnAction = _defaultFunction,
    this.rightBtnType = CustomNavigationBtnType.close,
  });

  static void _defaultFunction() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 48,
          color: Colors.white,
          padding: const EdgeInsets.only(left: 4, right: 8),
          child: Row(
            children: [
              // Left button area
              SizedBox(
                width: 44,
                height: 44,
                child: isDisplayLeftBtn
                    ? IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 20,
                        ),
                        onPressed: leftBtnAction,
                        color: _textColor,
                      )
                    : null,
              ),
              // Title (centered with Expanded)
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: _textColor,
                    fontFamily: 'WantedSansBold',
                  ),
                ),
              ),
              // Right button area
              SizedBox(
                width: 44,
                height: 44,
                child: isDisplayRightBtn
                    ? _buildRightButton()
                    : null,
              ),
            ],
          ),
        ),
        Container(height: 1, color: _dividerColor),
      ],
    );
  }

  Widget _buildRightButton() {
    if (rightBtnType == CustomNavigationBtnType.info) {
      return GestureDetector(
        onTap: rightBtnAction,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Text(
            "정보".tr,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _rightTextColor,
              fontFamily: 'WantedSansMedium',
            ),
          ),
        ),
      );
    }

    return IconButton(
      icon: Icon(
        _getRightBtnIcon(),
        size: 20,
      ),
      onPressed: rightBtnAction,
      color: _textColor,
    );
  }

  IconData _getRightBtnIcon() {
    switch (rightBtnType) {
      case CustomNavigationBtnType.close:
        return Icons.close;
      case CustomNavigationBtnType.info:
        return Icons.info_outline;
      case CustomNavigationBtnType.help:
        return Icons.help;
    }
  }
}
