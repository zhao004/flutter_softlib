import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_softlib/app/config.dart';
import 'package:flutter_softlib/app/http/http_api.dart';
import 'package:flutter_softlib/app/utils/toast_util.dart';
import 'package:get/get.dart';

import '../../models/http/results/report_cat_list_model.dart';
import '../../models/http/results/report_model.dart';
import '../../routes/app_pages.dart';

class ReportListLogic extends GetxController {
  int? id;

  ReportListLogic(this.id);

  HttpApi httpApi = Get.find<HttpApi>();
  bool isLoading = true;
  List<ReportData>? reports;
  int page = 1;

  EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishLoad: true,
    controlFinishRefresh: true,
  );

  @override
  void onReady() {
    super.onReady();
    loadInitial();
  }

  /// 初始加载（通常用于骨架屏）
  void loadInitial() {
    page = 1;
    _loadData();
  }

  /// 下拉刷新（第一页）
  void reload() {
    page = 1;
    _loadData(isRefresh: true);
  }

  /// 上拉加载下一页
  void loadNextPage() {
    page++;
    _loadData(isLoadMore: true);
  }

  /// 通用加载逻辑（内部私有）
  void _loadData({bool isRefresh = false, bool isLoadMore = false}) async {
    try {
      // 修复：使用正确的页码
      ReportCatListModel result = await httpApi.getReportCatLis(
        catId: id.toString(),
        page: page,
      );

      if (isLoading) {
        isLoading = false;
        if (result.code == 1) {
          reports = result.data ?? [];
          // 如果初始数据小于15条，禁用上拉加载
          if ((reports?.length ?? 0) < 15) {
            easyRefreshController.finishLoad(IndicatorResult.noMore);
          }
        } else {
          reports = [];
        }
        update(['reports']);
        return;
      }

      if (result.code == 1) {
        List<ReportData> newData = result.data ?? [];
        if (isLoadMore) {
          if (newData.isEmpty) {
            easyRefreshController.finishLoad(IndicatorResult.noMore);
          } else {
            reports?.addAll(newData);
            easyRefreshController.finishLoad(IndicatorResult.success);
          }
        } else {
          reports = newData;
          easyRefreshController.finishRefresh(IndicatorResult.success);
        }
      } else if (result.code == 2) {
        if (isLoadMore) {
          page--; // 回退页码
          easyRefreshController.finishLoad(IndicatorResult.noMore);
        } else {
          reports = [];
          easyRefreshController.finishRefresh(IndicatorResult.success);
        }
        if (result.msg?.isNotEmpty == true) {
          ToastUtil.error(result.msg!);
        }
      } else {
        if (isLoadMore) page--; // 回退页码
        _handleError(result.msg ?? '未知错误', isLoadMore);
      }
    } catch (e) {
      logger.e(e.toString());
      if (isLoadMore) page--; // 回退页码
      if (!isLoading) {
        _handleError('请求失败：${e.toString()}', isLoadMore);
      }
    } finally {
      update(['reports']);
    }
  }

  /// 错误统一处理
  void _handleError(String message, bool isLoadMore) {
    if (isLoadMore) {
      easyRefreshController.finishLoad(IndicatorResult.fail);
    } else {
      easyRefreshController.finishRefresh(IndicatorResult.fail);
    }
    ToastUtil.error(message);
  }

  ///跳转阅读页面
  Future<void> goToReadPage(ReportData report) async {
    // 参数验证
    if (report.id == null) {
      ToastUtil.error('报告ID无效');
      return;
    }
    // 显示加载提示
    EasyLoading.show(status: '正在加载...');
    try {
      // 获取报告详情
      ReportModel result = await httpApi.getReport(report.id!);
      // 隐藏加载提示
      EasyLoading.dismiss();
      // 检查响应结果
      if (result.code != 1) {
        EasyLoading.showError(result.msg ?? '获取报告详情失败');
        return;
      }
      // 验证数据完整性
      if (result.data == null) {
        EasyLoading.showError('报告数据为空');
        return;
      }
      // 跳转到阅读页面
      Get.toNamed(
        Routes.articleReading,
        arguments: {
          'title': result.data?.title ?? report.title ?? '无标题',
          'content': result.data?.content ?? '暂无内容',
        },
      );
    } catch (e) {
      // 隐藏加载提示
      EasyLoading.dismiss();
      // 记录错误日志
      logger.e('获取报告详情失败: ${e.toString()}');
      // 显示错误提示
      EasyLoading.showError('网络请求失败，请检查网络连接');
    }
  }

  /// 将秒级时间戳转换为格式化的本地时间字符串
  String formatDateTime(int timestamp, {int timezoneOffset = 8}) {
    if (timestamp <= 0) return '未知时间';
    DateTime dt = DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
      isUtc: true,
    ).add(Duration(hours: timezoneOffset));
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String year = dt.year.toString();
    String month = twoDigits(dt.month);
    String day = twoDigits(dt.day);
    String hour = twoDigits(dt.hour);
    String minute = twoDigits(dt.minute);
    return '$year-$month-$day $hour:$minute';
  }
}
