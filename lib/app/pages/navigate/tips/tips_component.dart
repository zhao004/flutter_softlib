import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'tips_logic.dart';

class TipsComponent extends StatefulWidget {
  const TipsComponent({super.key});

  @override
  State<TipsComponent> createState() => _TipsComponentState();
}

class _TipsComponentState extends State<TipsComponent> {
  final TipsLogic logic = Get.find<TipsLogic>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: logic.tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('线报'),
          bottom: TabBar(
            tabs: logic.tabs,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            overlayColor: WidgetStateColor.transparent,
          ),
        ),
        body: TabBarView(
          children:
              logic.tabs.map((tab) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return _buildItem();
                    },
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  /// 构建子组件
  Widget _buildItem() {
    return ListTile(
      visualDensity: VisualDensity(vertical: 3),
      leading: Image.network(
        'https://cdn.pixabay.com/photo/2013/12/14/07/29/lid-228366_1280.jpg',
        width: 120,
        fit: BoxFit.cover,
      ),
      title: Text(
        '这是一个标题这是一个标题这是一个标题这是一个标题这是一个标题这是一个标题',
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        child: Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 3,
              children: [
                Icon(
                  Icons.remove_red_eye,
                  size: 16,
                  color: Colors.black.withAlpha(100),
                ),
                Text(
                  '1000',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black.withAlpha(130),
                  ),
                ),
              ],
            ),
            //发布时间
            Text(
              '2023-10-01',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black.withAlpha(130),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
