import 'package:get/get.dart';

import '../../models/http/results/lzy_dir_search_model.dart';
import '../../routes/app_pages.dart';

class AppSearchResultLogic extends GetxController {
  String? title = Get.arguments['title'];
  List<LzyDirSearchData>? searchResults = Get.arguments['searchResults'];

  ///跳转到描述页面
  void goToView(LzyDirSearchData appInfo) {
    String dowUrl = appInfo.down ?? '';
    String? appId = appInfo.id;
    String? appSize = appInfo.size;
    Get.toNamed(
      Routes.appDetails,
      arguments: {'appId': appId, 'dowUrl': dowUrl, 'appSize': appSize},
    );
  }
}
