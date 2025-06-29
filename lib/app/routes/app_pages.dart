import 'package:flutter_softlib/app/pages/app_details/app_details_binding.dart';
import 'package:flutter_softlib/app/pages/app_details/app_details_page.dart';
import 'package:flutter_softlib/app/pages/app_download/app_download_binding.dart';
import 'package:flutter_softlib/app/pages/app_download/app_download_page.dart';
import 'package:flutter_softlib/app/pages/app_search/app_search_binding.dart';
import 'package:flutter_softlib/app/pages/app_search/app_search_page.dart';
import 'package:flutter_softlib/app/pages/article_reading/article_reading_binding.dart';
import 'package:flutter_softlib/app/pages/article_reading/article_reading_page.dart';
import 'package:get/get.dart';

import '../pages/navigate/navigate_binding.dart';
import '../pages/navigate/navigate_page.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const index = Routes.index;

  static final routes = [
    GetPage(
      name: _Paths.index,
      page: () => const NavigatePage(),
      binding: NavigateBinding(),
    ),
    GetPage(
      name: _Paths.appDownload,
      page: () => const AppDownloadPage(),
      binding: AppDownloadBinding(),
    ),
    GetPage(
      name: _Paths.appSearch,
      page: () => const AppSearchPage(),
      binding: AppSearchBinding(),
    ),
    GetPage(
      name: _Paths.appDetails,
      page: () => const AppDetailsPage(),
      binding: AppDetailsBinding(),
    ),
    GetPage(
      name: _Paths.articleReading,
      page: () => const ArticleReadingPage(),
      binding: ArticleReadingBinding(),
    ),
  ];
}
