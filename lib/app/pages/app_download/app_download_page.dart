import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_download_logic.dart';

class AppDownloadPage extends StatefulWidget {
  const AppDownloadPage({super.key});

  @override
  State<AppDownloadPage> createState() => _AppDownloadPageState();
}

class _AppDownloadPageState extends State<AppDownloadPage> {
  final AppDownloadLogic logic = Get.find<AppDownloadLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('软件下载列表')),
      body: Center(child: Text('软件下载列表')),
    );
  }

  @override
  void dispose() {
    Get.delete<AppDownloadLogic>();
    super.dispose();
  }
}
