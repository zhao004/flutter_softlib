import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config.dart';
import '../../models/http/results/lzy_dir_search_model.dart';
import 'app_search_result_logic.dart';

class AppSearchResultPage extends StatefulWidget {
  const AppSearchResultPage({super.key});

  @override
  State<AppSearchResultPage> createState() => _AppSearchResultPageState();
}

class _AppSearchResultPageState extends State<AppSearchResultPage> {
  final AppSearchResultLogic logic = Get.find<AppSearchResultLogic>();

  @override
  Widget build(BuildContext context) {
    List<LzyDirSearchData>? searchResults = logic.searchResults;
    if (searchResults == null || searchResults.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('"${logic.title}" 结果 0')),
        body: const Center(child: Text('暂无搜索结果')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('"${logic.title}" 结果 ${logic.searchResults?.length ?? 0}条'),
      ),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          LzyDirSearchData appInfo = searchResults[index];
          return _buildListItem(appInfo);
        },
      ),
    );
  }

  ///构建列表元素
  Widget _buildListItem(LzyDirSearchData appInfo) {
    return ListTile(
      minVerticalPadding: 10,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: appInfo.icon ?? '',
          fit: BoxFit.cover,
          width: 50,
          height: 50,
          placeholder: (context, url) => appIcon(50, 50),
          errorWidget: (context, url, error) => appIcon(50, 50),
        ),
      ),
      title: Text(
        appInfo.nameAll ?? '未知',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${appInfo.size}',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      trailing: FilledButton(
        onPressed: () => logic.goToView(appInfo),
        child: Text('查看'),
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<AppSearchResultLogic>();
    super.dispose();
  }
}
