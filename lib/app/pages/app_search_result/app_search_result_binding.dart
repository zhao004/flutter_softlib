import 'package:get/get.dart';

import 'app_search_result_logic.dart';

class AppSearchResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AppSearchResultLogic());
  }
}
