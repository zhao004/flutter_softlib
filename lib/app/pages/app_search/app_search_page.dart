import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import 'app_search_logic.dart';

class AppSearchPage extends StatefulWidget {
  const AppSearchPage({super.key});

  @override
  State<AppSearchPage> createState() => _AppSearchPageState();
}

class _AppSearchPageState extends State<AppSearchPage> {
  final AppSearchLogic logic = Get.find<AppSearchLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      extendBodyBehindAppBar: true,
      body: _buildBody(),
    );
  }

  /// 构建应用栏
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('软件搜索'),
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
    );
  }

  /// 构建页面主体
  Widget _buildBody() {
    return Container(
      decoration: _buildBackgroundDecoration(),
      child: KeyboardDismissOnTap(
        dismissOnCapturedTaps: true,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 60),
                _buildHeaderSection(),
                const SizedBox(height: 40),
                _buildSearchCard(),
                const SizedBox(height: 20),
                _buildTipSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建背景装饰
  BoxDecoration _buildBackgroundDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Theme.of(context).primaryColor.withAlpha(200),
          Theme.of(context).primaryColor.withAlpha(100),
          Theme.of(context).colorScheme.surface,
        ],
      ),
    );
  }

  /// 构建头部标题区域
  Widget _buildHeaderSection() {
    return Column(
      children: [
        Icon(
          Icons.search_rounded,
          size: 64,
          color: Colors.white.withAlpha(230),
        ),
        const SizedBox(height: 16),
        Text(
          '发现更多软件',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white.withAlpha(230),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '在这里搜索你需要的软件',
          style: TextStyle(fontSize: 16, color: Colors.white.withAlpha(178)),
        ),
      ],
    );
  }

  /// 构建搜索设置卡片
  Widget _buildSearchCard() {
    return Card(
      elevation: 12,
      shadowColor: Colors.black.withAlpha(25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.white.withAlpha(240)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardTitle(),
            const SizedBox(height: 20),
            _buildCategoryDropdown(),
            const SizedBox(height: 16),
            _buildSearchInput(),
            const SizedBox(height: 20),
            _buildSearchButton(),
          ],
        ),
      ),
    );
  }

  /// 构建卡片标题
  Widget _buildCardTitle() {
    return Text(
      '搜索设置',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  /// 构建分类下拉选择器
  Widget _buildCategoryDropdown() {
    return GetBuilder<AppSearchLogic>(
      id: 'menus',
      builder: (logic) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).primaryColor.withAlpha(76),
            ),
          ),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: '选择分类',
              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              prefixIcon: Icon(
                Icons.category_rounded,
                color: Theme.of(context).primaryColor,
              ),
            ),
            value: logic.selectedMenuType,
            items: logic.menuItems ?? [],
            onChanged: (value) {
              if (value != null) {
                logic.updateSelectedMenuType(value);
              }
            },
          ),
        );
      },
    );
  }

  /// 构建搜索输入框
  Widget _buildSearchInput() {
    return GetBuilder<AppSearchLogic>(
      id: 'searchInput',
      builder: (logic) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).primaryColor.withAlpha(76),
            ),
          ),
          child: TextField(
            controller: logic.searchController,
            decoration: InputDecoration(
              labelText: '输入搜索内容',
              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: Theme.of(context).primaryColor,
              ),
            ),
            onChanged: (value) => logic.updateSearchText(value),
            onSubmitted: (value) => logic.performSearch(),
          ),
        );
      },
    );
  }

  /// 构建搜索按钮
  Widget _buildSearchButton() {
    return GetBuilder<AppSearchLogic>(
      id: 'searchButton',
      builder: (logic) {
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton.icon(
            onPressed: logic.canSearch ? () => logic.performSearch() : null,
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            icon: _buildButtonIcon(logic.isSearching),
            label: Text(
              logic.isSearching ? '搜索中...' : '开始搜索',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
  }

  /// 构建按钮图标
  Widget _buildButtonIcon(bool isSearching) {
    return isSearching
        ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
        : const Icon(Icons.search_rounded, size: 20);
  }

  /// 构建提示信息区域
  Widget _buildTipSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).primaryColor.withAlpha(76)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '温馨提示：如果搜索结果不理想，建议尝试不同的关键词或多次搜索',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<AppSearchLogic>();
    super.dispose();
  }
}
