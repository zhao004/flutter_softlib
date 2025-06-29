import 'package:get/get.dart';

import 'app_download_logic.dart';

class AppDownloadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AppDownloadLogic());
  }
}
