import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppLogic extends GetxController {
  List<Tab> tabs = [
    Tab(text: '应用'),
    Tab(text: '游戏'),
    Tab(text: '工具'),
    Tab(text: '娱乐'),
  ];

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
