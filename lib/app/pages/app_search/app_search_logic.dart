import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_softlib/app/http/http_api.dart';
import 'package:flutter_softlib/app/models/http/results/app_model.dart';
import 'package:flutter_softlib/app/routes/app_pages.dart';
import 'package:flutter_softlib/app/utils/toast_util.dart';
import 'package:get/get.dart';

import '../../models/http/results/lzy_dir_search_model.dart';

class AppSearchLogic extends GetxController {
  HttpApi httpApi = Get.find<HttpApi>();
  List<DropdownMenuItem<String>>? menuItems;

  String? selectedMenuType;
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  bool isLoadingMenus = false;

  /// 计算是否可以搜索
  bool get canSearch =>
      selectedMenuType != null &&
      searchController.text.trim().isNotEmpty &&
      !isSearching &&
      !isLoadingMenus;

  @override
  void onReady() {
    super.onReady();
    _initializeData();
  }

  /// 初始化数据
  void _initializeData() {
    getMenuList();
  }

  /// 更新选中的菜单类型
  void updateSelectedMenuType(String type) {
    selectedMenuType = type;
    _updateButtonState();
  }

  /// 更新搜索文本
  void updateSearchText(String text) {
    _updateButtonState();
  }

  /// 更新按钮状态
  void _updateButtonState() {
    update(['menus', 'searchButton']);
  }

  /// 执行搜索
  Future<void> performSearch() async {
    if (!canSearch) return;
    _performHapticFeedback();
    _setSearchingState(true);
    try {
      FocusScope.of(Get.context!).unfocus();
      await _doSearch(selectedMenuType!, searchController.text.trim());
    } catch (e) {
      _handleSearchError(e);
    } finally {
      _setSearchingState(false);
    }
  }

  /// 设置搜索状态
  void _setSearchingState(bool searching) {
    isSearching = searching;
    update(['searchButton']);
  }

  /// 添加触觉反馈
  void _performHapticFeedback() {
    HapticFeedback.lightImpact();
  }

  /// 处理搜索错误
  void _handleSearchError(dynamic error) {
    ToastUtil.error('搜索过程中出现错误，请稍后再试');
  }

  /// 执行实际的搜索操作
  Future<void> _doSearch(String type, String query) async {
    LzyDirSearchModel result = await httpApi.getLzyDirSearch(
      url: type,
      keyword: query,
    );

    if (result.code != 1) {
      ToastUtil.error(result.msg ?? '搜索失败，请稍后再试');
      return;
    }

    _showSearchSuccessMessage();
    _navigateToResults(query, result.data);
  }

  /// 显示搜索成功消息
  void _showSearchSuccessMessage() {
    ToastUtil.success('搜索完成！');
  }

  /// 导航到搜索结果页面
  void _navigateToResults(String query, dynamic data) {
    Get.toNamed(
      Routes.appSearchResult,
      arguments: {'title': query, 'searchResults': data},
    );
  }

  /// 获取分类列表
  Future<void> getMenuList() async {
    _setLoadingState(true);

    try {
      AppModel result = await httpApi.getApp();
      if (result.code == 1) {
        _processMenuData(result.data);
      } else {
        _handleMenuError('获取分类列表失败');
      }
    } catch (e) {
      _handleMenuError('网络连接失败，请检查网络设置');
    } finally {
      _setLoadingState(false);
    }
  }

  /// 设置加载状态
  void _setLoadingState(bool loading) {
    isLoadingMenus = loading;
    update(['menus', 'searchButton']);
  }

  /// 处理菜单数据
  void _processMenuData(List<AppData>? apps) {
    menuItems ??= [];
    if (apps != null && apps.isNotEmpty) {
      for (var value in apps) {
        menuItems?.add(
          DropdownMenuItem(value: value.url, child: Text('${value.title}')),
        );
      }
    }
  }

  /// 处理菜单错误
  void _handleMenuError(String message) {
    ToastUtil.error(message);
  }

  @override
  void onClose() {
    _disposeResources();
    super.onClose();
  }

  /// 清理资源
  void _disposeResources() {
    searchController.dispose();
  }
}
