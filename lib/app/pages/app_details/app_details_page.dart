import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_details_logic.dart';

class AppDetailsPage extends StatefulWidget {
  const AppDetailsPage({super.key});

  @override
  State<AppDetailsPage> createState() => _AppDetailsPageState();
}

class _AppDetailsPageState extends State<AppDetailsPage> {
  final AppDetailsLogic logic = Get.find<AppDetailsLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('软件详情'),
        actionsPadding: EdgeInsets.only(right: 5),
        actions: [
          //分享
          IconButton(icon: Icon(Icons.share), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 软件头部
            _buildAppHeader(),
            // 软件详情
            _buildAppDetails(),
            // 软件示例图
            _buildAppScreenshots(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(26),
        child: FilledButton(onPressed: () {}, child: Text('下载软件')),
      ),
    );
  }

  /// 构建软件头部
  Widget _buildAppHeader() {
    return Container(
      // decoration: BoxDecoration(
      //   border: Border.all(
      //     color: Get.theme.primaryColor.withValues(alpha: 0.6),
      //     width: 1,
      //   ),
      //   borderRadius: BorderRadius.circular(18),
      // ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      margin: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: ListTile(
        horizontalTitleGap: 18,
        visualDensity: VisualDensity(vertical: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            'https://api.krrz.cn/uploads/20250626/6b373cd3d096bd5711eda16ba8c817f3.jpg',
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          '软件标题',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                decoration: BoxDecoration(
                  color: Get.theme.primaryColor.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '50M',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                decoration: BoxDecoration(
                  color: Get.theme.primaryColor.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '昨天:21:00',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建软件详情
  Widget _buildAppDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: ListTile(
        minVerticalPadding: 10,
        contentPadding: EdgeInsets.all(0),
        title: Text('软件介绍', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            '这是一个示例软件的详细介绍。它提供了丰富的功能和良好的用户体验。',
            style: TextStyle(color: Colors.grey[800]),
          ),
        ),
      ),
    );
  }

  /// 构建软件示例图
  Widget _buildAppScreenshots() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text('软件截图', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Card(
          margin: EdgeInsets.symmetric(vertical: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://api.krrz.cn/uploads/20250626/6b373cd3d096bd5711eda16ba8c817f3.jpg',
              // fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<AppDetailsLogic>();
    super.dispose();
  }
}
