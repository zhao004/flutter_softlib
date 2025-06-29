import 'package:get/get.dart';

import 'app/app_logic.dart';
import 'home/home_logic.dart';
import 'navigate_logic.dart';
import 'tips/tips_logic.dart';

class NavigateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NavigateLogic());
    Get.lazyPut(() => HomeLogic());
    Get.lazyPut(() => AppLogic());
    Get.lazyPut(() => TipsLogic());
  }
}
