import 'package:flutter/material.dart';
import 'package:flutter_softlib/app/pages/navigate/app/app_component.dart';
import 'package:flutter_softlib/app/pages/navigate/home/home_component.dart';
import 'package:flutter_softlib/app/pages/navigate/tips/tips_component.dart';
import 'package:get/get.dart';

import '../../widgets/icon_font.dart';

class NavigateLogic extends GetxController {
  List<NavigationDestination> labels = [
    NavigationDestination(
      icon: Icon(IconFont.home),
      label: '首页',
      selectedIcon: Icon(IconFont.homeFill),
    ),
    NavigationDestination(
      icon: Icon(IconFont.appB),
      label: '应用',
      selectedIcon: Icon(IconFont.appBFill),
    ),
    NavigationDestination(
      icon: Icon(Icons.tips_and_updates_outlined),
      label: '线报',
      selectedIcon: Icon(Icons.tips_and_updates),
    ),
  ];
  List<Widget> pages = [HomeComponent(), AppComponent(), TipsComponent()];
  PageController pageController = PageController();
  int currentIndex = 0;

  /// 切换页面
  void changePage(int index) {
    currentIndex = index;
    pageController.jumpToPage(index);
    update(['navigate']);
  }
}
