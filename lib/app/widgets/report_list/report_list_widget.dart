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
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 3),
          );
        }
        if (reports == null || reports.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.article_outlined,
                  size: 64,
                  color: Theme.of(context).disabledColor.withAlpha(100),
                ),
                const SizedBox(height: 16),
                Text(
                  '暂无相关报告',
                  style: TextStyle(
                    color: Theme.of(context).disabledColor,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          );
        }
        return EasyRefresh(
          onLoad: logic.loadNextPage,
          onRefresh: logic.reload,
          controller: logic.easyRefreshController,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: reports.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              ReportData report = reports[index];
              return _buildItem(context, report);
            },
          ),
        );
      },
    );
  }

  /// 构建列表元素
  Widget _buildItem(BuildContext context, ReportData report) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final secondaryTextColor = isDark ? Colors.white60 : Colors.black45;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 30 : 10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => logic.goToReadPage(report),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 封面图
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: report.image ?? '',
                    width: 110,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: theme.dividerColor.withAlpha(20),
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      Assets.imagesSucceed,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // 内容区
                Expanded(
                  child: SizedBox(
                    height: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 标题
                        Text(
                          report.title ?? '无标题',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                        // 底部信息
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 浏览量
                            Row(
                              children: [
                                Icon(
                                  Icons.visibility_outlined,
                                  size: 14,
                                  color: secondaryTextColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${report.views ?? 0}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: secondaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                            // 时间
                            Text(
                              logic.formatDateTime(report.createtime ?? 0),
                              style: TextStyle(
                                fontSize: 12,
                                color: secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
