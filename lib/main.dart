import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_softlib/app/database/database.dart';
import 'package:flutter_softlib/app/http/http_api.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(ignoreSsl: true);
  Get.put<AppDatabase>(AppDatabase(), permanent: true);
  Get.lazyPut(() => HttpApi(Dio()));
  runApp(
    GetMaterialApp(
      title: '软件库App',
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.index,
      getPages: AppPages.routes,
      builder: EasyLoading.init(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [Locale("en"), Locale("zh")],
    ),
  );
}
