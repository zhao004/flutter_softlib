import 'package:flutter_softlib/app/utils/toast_util.dart';
import 'package:get/get.dart';

import '../../../config.dart';
import '../../../http/http_api.dart';
import '../../../models/http/results/report_cat_model.dart';

class TipsLogic extends GetxController {
  HttpApi httpApi = Get.find<HttpApi>();
  List<ReportCatData>? reportCatList;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getTipsCategory();
  }

  ///获取线报分类
  Future<void> getTipsCategory() async {
    try {
      ReportCatModel reportCat = await httpApi.getReportCat();
      if (reportCat.code == 1) {
        reportCatList = reportCat.data;
      }
      update(['reportCatList']);
    } catch (e) {
      logger.e(e.toString());
      ToastUtil.error(e.toString());
    }
  }
}
