import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_softlib/app/config.dart';
import 'package:flutter_softlib/app/http/http_api.dart';
import 'package:flutter_softlib/app/models/http/results/lzy_dir_parse_model.dart';
import 'package:flutter_softlib/app/routes/app_pages.dart';
import 'package:flutter_softlib/app/utils/toast_util.dart';
import 'package:get/get.dart';

enum _FetchType { initial, refresh, loadMore }

class AppListLogic extends GetxController {
  final String? url;

  AppListLogic({required this.url});

  final HttpApi _httpApi = Get.find<HttpApi>();
  final EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishLoad: true,
    controlFinishRefresh: true,
  );

  bool isLoading = true;
  List<LzyDirParseData> appList = [];
  int _page = 1;
  static const int _pageSize = 15;

  @override
  void onReady() {
    super.onReady();
    loadInitial();
  }

  void loadInitial() {
    _page = 1;
    isLoading = true;
    update(['apps']);
    _fetchData(_FetchType.initial);
  }

  Future<void> reload() async {
    _page = 1;
    await _fetchData(_FetchType.refresh);
  }

  Future<void> loadNextPage() async {
    _page++;
    await _fetchData(_FetchType.loadMore);
  }

  Future<void> _fetchData(_FetchType type) async {
    try {
      final result = await _httpApi.getLzyDirParse(url: url, pgs: _page);

      if (result.code == 1) {
        final newData = result.data ?? [];
        if (type == _FetchType.loadMore) {
          appList.addAll(newData);
        } else {
          appList = newData;
        }
        final hasNoMore = newData.length < _pageSize;
        _finishTask(type, IndicatorResult.success, hasNoMore: hasNoMore);
      } else if (result.code == 2) {
        if (type == _FetchType.loadMore) {
          _rollbackPageIfLoadMore(type);
        } else {
          appList = [];
        }
        _finishTask(type, IndicatorResult.noMore, hasNoMore: true);
        if (result.msg?.isNotEmpty == true) {
          ToastUtil.error(result.msg!);
        }
      } else {
        _rollbackPageIfLoadMore(type);
        _finishTask(type, IndicatorResult.fail, error: result.msg ?? '未知错误');
      }
    } catch (e) {
      logger.e(e.toString());
      _rollbackPageIfLoadMore(type);
      _finishTask(type, IndicatorResult.fail, error: '请求失败：${e.toString()}');
    } finally {
      isLoading = false;
      update(['apps']);
    }
  }

  void _rollbackPageIfLoadMore(_FetchType type) {
    if (type == _FetchType.loadMore) {
      _page = (_page - 1).clamp(1, _page);
    }
  }

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
        easyRefreshController.resetFooter();
        if (hasNoMore) {
          easyRefreshController.finishLoad(IndicatorResult.noMore);
        }
      }
    } else {
      easyRefreshController.finishLoad(
        hasNoMore ? IndicatorResult.noMore : result,
      );
    }

    if (error != null && type != _FetchType.initial) {
      ToastUtil.error(error);
    }
  }

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
