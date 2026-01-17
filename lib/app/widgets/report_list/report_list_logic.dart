import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_softlib/app/config.dart';
import 'package:flutter_softlib/app/http/http_api.dart';
import 'package:flutter_softlib/app/utils/toast_util.dart';
import 'package:get/get.dart';

import '../../models/http/results/report_cat_list_model.dart';
import '../../routes/app_pages.dart';

enum _FetchType { initial, refresh, loadMore }

class ReportListLogic extends GetxController {
  final int? id;

  ReportListLogic(this.id);

  final HttpApi _httpApi = Get.find<HttpApi>();
  final EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishLoad: true,
    controlFinishRefresh: true,
  );

  bool isLoading = true; // 骨架屏/初始加载标志
  List<ReportData> reports = [];
  int _page = 1;
  static const int _pageSize = 15;

  @override
  void onReady() {
    super.onReady();
    loadInitial();
  }

  /// 初始加载
  void loadInitial() {
    _page = 1;
    isLoading = true;
    update(['reports']);
    _fetchData(_FetchType.initial);
  }

  /// 下拉刷新
  Future<void> reload() async {
    _page = 1;
    await _fetchData(_FetchType.refresh);
  }

  /// 上拉加载
  Future<void> loadNextPage() async {
    _page++;
    await _fetchData(_FetchType.loadMore);
  }

  /// 核心数据抓取逻辑
  Future<void> _fetchData(_FetchType type) async {
    try {
      final result = await _httpApi.getReportCatLis(
        catId: id.toString(),
        page: _page,
      );

      if (result.code == 1) {
        final newData = result.data ?? [];

        if (type == _FetchType.loadMore) {
          reports.addAll(newData);
        } else {
          reports = newData;
        }

        // 判断是否有更多数据
        final hasNoMore = newData.length < _pageSize;
        _finishTask(type, IndicatorResult.success, hasNoMore: hasNoMore);
      } else if (result.code == 2) {
        // 业务层面的"空"或"无更多"
        if (type != _FetchType.loadMore) reports = [];
        _finishTask(type, IndicatorResult.noMore);
      } else {
        throw result.msg ?? '服务器异常';
      }
    } catch (e) {
      logger.e("ReportList fetch error: $e");
      if (type == _FetchType.loadMore) _page--; // 回退页码
      _finishTask(type, IndicatorResult.fail, error: e.toString());
    } finally {
      isLoading = false;
      update(['reports']);
    }
  }

  /// 统一结束刷新/加载状态
  void _finishTask(
    _FetchType type,
    IndicatorResult result, {
    bool hasNoMore = false,
    String? error,
  }) {
    if (type == _FetchType.refresh || type == _FetchType.initial) {
      easyRefreshController.finishRefresh(result);
      if (result == IndicatorResult.success ||
          result == IndicatorResult.noMore) {
        // 刷新成功后，如果新数据就不满一页，重置并设置noMore
        easyRefreshController.resetFooter();
        if (hasNoMore) easyRefreshController.finishLoad(IndicatorResult.noMore);
      }
    } else if (type == _FetchType.loadMore) {
      easyRefreshController.finishLoad(
        hasNoMore ? IndicatorResult.noMore : result,
      );
    }

    if (error != null && type != _FetchType.initial) {
      ToastUtil.error(error);
    }
  }

  /// 跳转阅读页面
  Future<void> goToReadPage(ReportData report) async {
    final reportId = report.id;
    if (reportId == null) {
      ToastUtil.error('报告内容不存在');
      return;
    }

    EasyLoading.show(status: '读取中...');
    try {
      final result = await _httpApi.getReport(reportId);
      if (result.code == 1 && result.data != null) {
        Get.toNamed(
          Routes.articleReading,
          arguments: {
            'title': result.data?.title ?? report.title ?? '报告详情',
            'content': result.data?.content ?? '',
          },
        );
      } else {
        ToastUtil.error(result.msg ?? '获取详情失败');
      }
    } catch (e) {
      logger.e("Get report detail error: $e");
      ToastUtil.error('网络连接异常');
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// 时间格式化
  String formatDateTime(int timestamp) {
    if (timestamp <= 0) return '-';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }
}
