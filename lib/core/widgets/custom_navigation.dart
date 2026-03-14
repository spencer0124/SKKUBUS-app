import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum CustomNavigationBtnType { close, info, help }

class CustomNavigationBar extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final bool isDisplayLeftBtn;
  final bool isDisplayRightBtn;
  final VoidCallback leftBtnAction;
  final VoidCallback rightBtnAction;
  final CustomNavigationBtnType rightBtnType;

  const CustomNavigationBar({
    super.key,
    this.title = 'loading',
    this.backgroundColor = Colors.white,
    this.isDisplayLeftBtn = true,
    this.isDisplayRightBtn = true,
    this.leftBtnAction = _defaultFunction,
    this.rightBtnAction = _defaultFunction,
    this.rightBtnType = CustomNavigationBtnType.close,
  });

  static void _defaultFunction() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 48,
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              SizedBox(
                // width: 45,
                height: 45,
                child:
                    isDisplayLeftBtn
                        ? IconButton(
                          icon: const Icon(Icons.chevron_left, size: 30.0),
                          onPressed: leftBtnAction,
                          color: Colors.white,
                        )
                        : null,
              ),
              if (rightBtnType == CustomNavigationBtnType.info)
                const SizedBox(width: 35),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              color: Colors.white,
              fontFamily: 'WantedSansBold',
            ),
          ),
          const Spacer(),
          SizedBox(
            // width: 45,
            height: 45,
            child:
                isDisplayRightBtn
                    ? GestureDetector(
                      onTap: rightBtnAction,
                      child: Row(
                        children: [
                          Icon(
                            _getRightBtnIcon(),
                            size: 23,
                            color: Colors.white,
                          ),
                          if (rightBtnType == CustomNavigationBtnType.info)
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 4.0,
                                right: 14.0,
                              ),
                              child: SizedBox(
                                width: 35,
                                child: Text(
                                  "정보".tr,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: 'WantedSansBold',
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                    : const SizedBox(width: 45 + 27, height: 45),
          ),
        ],
      ),
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
