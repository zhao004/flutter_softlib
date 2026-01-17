import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config.dart';
import '../../models/http/results/lzy_dir_parse_model.dart';
import 'app_list_logic.dart';

class AppListWidget extends StatefulWidget {
  final String? url;

  const AppListWidget({super.key, required this.url});

  @override
  State<AppListWidget> createState() => _AppListWidgetState();
}

class _AppListWidgetState extends State<AppListWidget>
    with AutomaticKeepAliveClientMixin<AppListWidget> {
  late AppListLogic logic;

  @override
  void initState() {
    super.initState();
    logic = Get.find<AppListLogic>(tag: widget.url);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<AppListLogic>(
      id: 'apps',
      tag: widget.url,
      builder: (logic) {
        List<LzyDirParseData>? appList = logic.appList;
        if (logic.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (appList == null || appList.isEmpty) {
          return const Center(child: Text('暂无数据'));
        }
        return EasyRefresh(
          onLoad: logic.loadNextPage,
          onRefresh: logic.reload,
          controller: logic.easyRefreshController,
          child: ListView.builder(
            itemCount: appList.length,
            itemBuilder: (context, index) {
              LzyDirParseData appInfo = appList[index];
              return _buildListItem(appInfo);
            },
          ),
        );
      },
    );
  }

  /// 构建列表元素
  Widget _buildListItem(LzyDirParseData appInfo) {
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
        appInfo.nameAll ?? '未知应用',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            appInfo.size ?? '未知大小',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[300]
                  : Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            appInfo.time ?? '未知时间',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[300]
                  : Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      trailing: FilledButton(
        onPressed: () => logic.goToView(appInfo),
        child: const Text('查看'),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
