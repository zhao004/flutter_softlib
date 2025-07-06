import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_softlib/app/config.dart';
import 'package:flutter_softlib/app/http/http_api.dart';
import 'package:flutter_softlib/app/models/http/results/lzy_dir_parse_model.dart';
import 'package:flutter_softlib/app/routes/app_pages.dart';
import 'package:flutter_softlib/app/utils/toast_util.dart';
import 'package:get/get.dart';

class AppListLogic extends GetxController {
  String? url;

  AppListLogic({required this.url});

  HttpApi httpApi = Get.find<HttpApi>();
  bool isLoading = true;
  List<LzyDirParseData>? appList;
  int page = 1;

  EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishLoad: true,
    controlFinishRefresh: true,
  );

  @override
  void onReady() {
    // TODO: implement onReady
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
      final result = await httpApi.getLzyDirParse(url: url, pgs: page);

      if (isLoading) {
        isLoading = false;
        if (result.code == 1) {
          appList = result.data ?? [];
          // 如果初始数据小于15条，禁用上拉加载
          if ((appList?.length ?? 0) < 15) {
            easyRefreshController.finishLoad(IndicatorResult.noMore);
          }
        } else {
          appList = [];
        }
        update(['apps']);
        return;
      }

      if (result.code == 1) {
        List<LzyDirParseData> newData = result.data ?? [];
        if (isLoadMore) {
          if (newData.isEmpty) {
            easyRefreshController.finishLoad(IndicatorResult.noMore);
          } else {
            appList?.addAll(newData);
            easyRefreshController.finishLoad(IndicatorResult.success);
          }
        } else {
          appList = newData;
          easyRefreshController.finishRefresh(IndicatorResult.success);
        }
      } else if (result.code == 2) {
        if (isLoadMore) {
          page--; // 回退页码
          easyRefreshController.finishLoad(IndicatorResult.noMore);
        } else {
          appList = [];
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
      update(['apps']);
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

  ///跳转到描述页面
  void goToView(LzyDirParseData appInfo) {
    String dowUrl = appInfo.down ?? '';
    String? appId = appInfo.id;
    String? appSize = appInfo.size;
    Get.toNamed(
      Routes.appDetails,
      arguments: {'appId': appId, 'dowUrl': dowUrl, 'appSize': appSize},
    );
  }
}
