import 'package:get/get.dart';

import 'article_reading_logic.dart';

class ArticleReadingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ArticleReadingLogic());
  }
}
