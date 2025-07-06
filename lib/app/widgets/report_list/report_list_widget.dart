import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../generated/assets.dart';
import '../../models/http/results/report_cat_list_model.dart';
import 'report_list_logic.dart';

class ReportListWidget extends StatefulWidget {
  final int? id;

  const ReportListWidget({super.key, this.id});

  @override
  State<ReportListWidget> createState() => _ReportListWidgetState();
}

class _ReportListWidgetState extends State<ReportListWidget>
    with AutomaticKeepAliveClientMixin<ReportListWidget> {
  late ReportListLogic logic;

  @override
  void initState() {
    super.initState();
    logic = Get.find<ReportListLogic>(tag: widget.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<ReportListLogic>(
      id: 'reports',
      tag: widget.id.toString(),
      builder: (logic) {
        List<ReportData>? reports = logic.reports;
        if (logic.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (reports == null || reports.isEmpty) {
          return const Center(child: Text('暂无数据'));
        }
        return EasyRefresh(
          onLoad: logic.loadNextPage,
          onRefresh: logic.reload,
          controller: logic.easyRefreshController,
          child: ListView.builder(
            itemCount: reports.length,
            itemBuilder: (_, index) {
              ReportData report = reports[index];
              return _buildItem(report);
            },
          ),
        );
      },
    );
  }

  /// 构建列表元素
  Widget _buildItem(ReportData report) {
    return ListTile(
      onTap: () => logic.goToReadPage(report),
      visualDensity: const VisualDensity(vertical: 3),
      leading: CachedNetworkImage(
        imageUrl: report.image ?? '',
        width: 130,
        fit: BoxFit.cover,
        placeholder:
            (context, url) =>
                Image.asset(Assets.imagesSucceed, fit: BoxFit.cover),
        errorWidget:
            (context, url, error) =>
                Image.asset(Assets.imagesSucceed, fit: BoxFit.cover),
      ),
      title: Text(
        report.title ?? '无标题',
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  "${report.views ?? 0}",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black.withAlpha(130),
                  ),
                ),
              ],
            ),
            // 发布时间
            Text(
              logic.formatDateTime(report.createtime ?? 0),
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

  @override
  bool get wantKeepAlive => true;
}
