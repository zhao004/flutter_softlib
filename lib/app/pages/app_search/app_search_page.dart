import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_search_logic.dart';

class AppSearchPage extends StatefulWidget {
  const AppSearchPage({super.key});

  @override
  State<AppSearchPage> createState() => _AppSearchPageState();
}

class _AppSearchPageState extends State<AppSearchPage> {
  final AppSearchLogic logic = Get.find<AppSearchLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('软件搜索')),
      body: Center(child: Text('软件搜索')),
    );
  }

  @override
  void dispose() {
    Get.delete<AppSearchLogic>();
    super.dispose();
  }
}
