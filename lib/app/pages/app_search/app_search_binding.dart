import 'package:get/get.dart';

import 'app_search_logic.dart';

class AppSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AppSearchLogic());
  }
}
