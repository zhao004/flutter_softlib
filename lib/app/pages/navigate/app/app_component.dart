import 'package:flutter/material.dart';
import 'package:flutter_softlib/app/widgets/app_list/app_list_logic.dart';
import 'package:flutter_softlib/app/widgets/app_list/app_list_widget.dart';
import 'package:get/get.dart';

import '../../../models/http/results/app_model.dart';
import '../../../routes/app_pages.dart';
import 'app_logic.dart';

class AppComponent extends StatefulWidget {
  const AppComponent({super.key});

  @override
  State<AppComponent> createState() => _AppComponentState();
}

class _AppComponentState extends State<AppComponent> {
  final AppLogic logic = Get.find<AppLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppLogic>(
      id: 'catList',
      builder: (logic) {
        List<AppData>? catList = logic.catList;
        if (catList == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (catList.isEmpty) {
          return const Center(child: Text('暂无数据'));
        }
        return DefaultTabController(
          length: catList.length,
          child: Scaffold(
            appBar: AppBar(
              title: Text('软件', style: TextStyle(fontWeight: FontWeight.w500)),
              bottom: TabBar(
                tabs:
                    catList
                        .map((app) => Tab(text: app.title ?? '未知标题'))
                        .toList(),
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                overlayColor: WidgetStateColor.transparent,
              ),
              actionsPadding: const EdgeInsets.only(right: 5),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => Get.toNamed(Routes.appSearch),
                ),
                IconButton(
                  icon: const Icon(Icons.file_download),
                  onPressed: () => Get.toNamed(Routes.appDownload),
                ),
              ],
            ),
            body: TabBarView(
              children:
                  catList.map((app) {
                    Get.lazyPut(() => AppListLogic(url: app.url), tag: app.url);
                    return AppListWidget(url: app.url);
                  }).toList(),
            ),
          ),
        );
      },
    );
  }
}
