import 'package:dio/dio.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_softlib/app/database/database.dart';
import 'package:flutter_softlib/app/http/http_api.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

/// 应用程序主入口
Future<void> main() async {
  try {
    // 确保Flutter框架初始化
    WidgetsFlutterBinding.ensureInitialized();
    // 初始化各种服务
    await _initializeServices();
    // 运行应用
    runApp(const SoftLibApp());
  } catch (error, stackTrace) {
    // 捕获启动异常
    debugPrint('应用启动失败: $error');
    debugPrint('堆栈跟踪: $stackTrace');
    // 运行错误页面
    runApp(_buildErrorApp(error.toString()));
  }
}

/// 初始化应用服务
Future<void> _initializeServices() async {
  // 初始化下载器
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  // 初始化数据库
  Get.put<AppDatabase>(AppDatabase(), permanent: true);
  // 初始化HTTP服务
  Get.lazyPut(() => HttpApi(_createDioInstance()));
  // 配置EasyLoading
  _configureEasyLoading();
  // 设置设备方向
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

/// 创建Dio实例
Dio _createDioInstance() {
  final dio = Dio();
  // 配置默认选项
  dio.options.connectTimeout = const Duration(seconds: 6);
  dio.options.receiveTimeout = const Duration(seconds: 6);
  dio.options.sendTimeout = const Duration(seconds: 6);
  return dio;
}

/// 配置EasyLoading样式
void _configureEasyLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

/// 软件库应用主组件
class SoftLibApp extends StatelessWidget {
  const SoftLibApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '软件库App',
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.index,
      getPages: AppPages.routes,
      builder: EasyLoading.init(),
      theme: FlexThemeData.light(scheme: FlexScheme.blueM3),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.blueM3),
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale("zh", "CN"), Locale("en", "US")],
      locale: const Locale("zh", "CN"),
    );
  }
}

/// 构建错误应用页面
Widget _buildErrorApp(String error) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: Colors.red[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
              const SizedBox(height: 16),
              Text(
                '应用启动失败',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.red[600]),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // 重启应用
                  SystemNavigator.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white,
                ),
                child: const Text('退出应用'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
