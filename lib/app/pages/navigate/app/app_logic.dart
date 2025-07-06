import 'package:flutter_softlib/app/utils/toast_util.dart';
import 'package:get/get.dart';

import '../../../config.dart';
import '../../../http/http_api.dart';
import '../../../models/http/results/app_model.dart';

class AppLogic extends GetxController {
  HttpApi httpApi = Get.find<HttpApi>();
  List<AppData>? catList;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getAppList();
  }

  /// 获取软件列表
  Future<void> getAppList() async {
    try {
      AppModel results = await httpApi.getApp();
      if (results.code == 1) {
        catList = results.data;
        update(['catList']);
      }
    } catch (e) {
      logger.e(e.toString());
      ToastUtil.error(e.toString());
    }
  }
}
