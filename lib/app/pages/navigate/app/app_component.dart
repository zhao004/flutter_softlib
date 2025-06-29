import 'package:flutter/material.dart';
import 'package:flutter_softlib/app/routes/app_pages.dart';
import 'package:get/get.dart';

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
    return DefaultTabController(
      length: logic.tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('软件'),
          bottom: TabBar(
            tabs: logic.tabs,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            overlayColor: WidgetStateColor.transparent,
          ),
          actionsPadding: const EdgeInsets.only(right: 5),
          actions: [
            // 右侧操作按钮
            IconButton(icon: const Icon(Icons.search), onPressed: () {}),
            IconButton(icon: const Icon(Icons.file_download), onPressed: () {}),
          ],
        ),
        body: TabBarView(
          children:
              logic.tabs.map((tab) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return _buildListItem('${tab.text}标题 - Item $index');
                    },
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  ///构建列表元素
  Widget _buildListItem(String title) {
    return ListTile(
      minVerticalPadding: 10,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          'https://image.woozooo.com/image/ico/2024/03/06/167220815-28.png?x-oss-process=image/auto-orient,1/resize,m_fill,w_150,h_150/format,png',
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '61.2M',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '昨天21:00',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      trailing: FilledButton(
        onPressed: () => Get.toNamed(Routes.appDetails),
        child: Text('查看'),
      ),
    );
  }
}
