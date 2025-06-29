import 'package:get/get.dart';

import 'app_details_logic.dart';

class AppDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AppDetailsLogic());
  }
}
