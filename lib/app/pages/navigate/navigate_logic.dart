import 'package:flutter/material.dart';
import 'package:flutter_softlib/app/http/http_api.dart';
import 'package:flutter_softlib/app/pages/navigate/app/app_component.dart';
import 'package:flutter_softlib/app/pages/navigate/home/home_component.dart';
import 'package:flutter_softlib/app/pages/navigate/tips/tips_component.dart';
import 'package:flutter_softlib/app/utils/jump_util.dart';
import 'package:flutter_softlib/app/utils/toast_util.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../models/http/results/latest_version_model.dart';
import '../../utils/permission_utils.dart';
import '../../widgets/icon_font.dart';

class NavigateLogic extends GetxController {
  List<NavigationDestination> labels = [
    NavigationDestination(
      icon: Icon(IconFont.home),
      label: '首页',
      selectedIcon: Icon(IconFont.homeFill),
    ),
    NavigationDestination(
      icon: Icon(IconFont.appB),
      label: '应用',
      selectedIcon: Icon(IconFont.appBFill),
    ),
    NavigationDestination(
      icon: Icon(Icons.tips_and_updates_outlined),
      label: '线报',
      selectedIcon: Icon(Icons.tips_and_updates),
    ),
  ];
  List<Widget> pages = [HomeComponent(), AppComponent(), TipsComponent()];
  PageController pageController = PageController();
  int currentIndex = 0;
  HttpApi httpApi = Get.find<HttpApi>();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    //请求权限
    _requestPermissionsOnStartup();
    //检查更新
    _checkUpdate();
  }

  /// 切换页面
  void changePage(int index) {
    currentIndex = index;
    pageController.jumpToPage(index);
    update(['navigate']);
  }

  /// 权限请求
  Future<void> _requestPermissionsOnStartup() async {
    await PermissionUtils.requestAppPermissions(Get.context!);
  }

  ///检测更新
  Future<void> _checkUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    LatestVersionModel result = await httpApi.getLatestVersion(version);

    if (result.code == 1) {
      LatestVersionData? latestVersionData = result.data;
      if (latestVersionData != null) {
        _showUpdateDialog(latestVersionData);
      }
    }
  }

  /// 显示更新弹窗
  void _showUpdateDialog(LatestVersionData versionData) {
    String versionName = versionData.version ?? "未知版本";
    String title = versionData.title ?? "发现新版本";
    String content = versionData.content ?? "请及时更新以获取最佳体验";
    String? downloadUrl = versionData.dowUrl;
    bool forcedUpdate = versionData.forcedSwitch ?? false;

    if (downloadUrl == null || downloadUrl.isEmpty) return;

    showDialog(
      context: Get.context!,
      barrierDismissible: !forcedUpdate,
      builder: (context) => _buildUpdateDialog(
        context,
        title,
        versionName,
        content,
        downloadUrl,
        forcedUpdate,
      ),
    );
  }

  /// 构建更新弹窗
  Widget _buildUpdateDialog(
    BuildContext context,
    String title,
    String versionName,
    String content,
    String downloadUrl,
    bool forcedUpdate,
  ) {
    return PopScope(
      canPop: !forcedUpdate,
      // onPopInvokedWithResult: (bool didPop, dynamic result) {
      //   if (forcedUpdate && didPop) {
      //     // 如果是强制更新，可以在这里阻止弹窗被关闭
      //     // 但其实 canPop: false 就已经禁止了
      //   }
      // },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          decoration: _buildDialogDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogHeader(title, versionName),
              _buildDialogContent(context, content),
              _buildDialogActions(context, downloadUrl, forcedUpdate),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建弹窗装饰
  BoxDecoration _buildDialogDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.blue.shade50, Colors.white],
      ),
    );
  }

  /// 构建弹窗头部
  Widget _buildDialogHeader(String title, String versionName) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(Get.context!).primaryColor.withAlpha(160),
            Theme.of(Get.context!).primaryColor.withAlpha(230),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          _buildHeaderTitle(title),
          const SizedBox(height: 8),
          _buildVersionBadge(versionName),
        ],
      ),
    );
  }

  /// 构建头部标题
  Widget _buildHeaderTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  /// 构建版本徽章
  Widget _buildVersionBadge(String versionName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        'v$versionName',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// 构建弹窗内容
  Widget _buildDialogContent(BuildContext context, String content) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: HtmlWidget(
            content,
            textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.6,
              color: Colors.grey.shade700,
            ),
            customStylesBuilder: _buildCustomStyles,
            onTapUrl: _handleUrlTap,
            renderMode: RenderMode.column,
          ),
        ),
      ),
    );
  }

  /// 构建自定义样式
  Map<String, String>? _buildCustomStyles(element) {
    switch (element.localName) {
      case 'p':
        return {'margin-bottom': '12px', 'line-height': '1.6'};
      case 'ul':
        return {
          'margin-left': '20px',
          'margin-bottom': '12px',
          'padding-left': '0px',
        };
      case 'li':
        return {'margin-bottom': '6px', 'line-height': '1.5'};
      case 'h1':
      case 'h2':
      case 'h3':
        return {
          'color': '#333333',
          'font-weight': 'bold',
          'margin-bottom': '10px',
          'margin-top': '16px',
        };
      case 'img':
        return {
          'max-width': '100%',
          'height': 'auto',
          'border-radius': '8px',
          'margin': '8px 0',
        };
      default:
        return null;
    }
  }

  /// 处理链接点击
  Future<bool> _handleUrlTap(String url) async {
    try {
      JumpUtil.openUrl(url);
    } catch (e) {
      ToastUtil.error('无法打开链接: $url');
    }
    return false;
  }

  /// 构建弹窗按钮区域
  Widget _buildDialogActions(
    BuildContext context,
    String downloadUrl,
    bool forcedUpdate,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          if (!forcedUpdate) ...[
            _buildCancelButton(context),
            const SizedBox(width: 12),
          ],
          _buildUpdateButton(context, downloadUrl, forcedUpdate),
        ],
      ),
    );
  }

  /// 构建取消按钮
  Widget _buildCancelButton(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: () => Navigator.of(context).pop(),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Text(
          '以后再说',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// 构建更新按钮
  Widget _buildUpdateButton(
    BuildContext context,
    String downloadUrl,
    bool forcedUpdate,
  ) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () =>
            _handleUpdateButtonTap(context, downloadUrl, forcedUpdate),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(Get.context!).primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.download, size: 18),
            const SizedBox(width: 6),
            const Text(
              '立即更新',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  /// 处理更新按钮点击
  Future<void> _handleUpdateButtonTap(
    BuildContext context,
    String downloadUrl,
    bool forcedUpdate,
  ) async {
    try {
      JumpUtil.openUrl(downloadUrl);
    } catch (e) {
      ToastUtil.error('打开下载链接失败');
    }
    if (!forcedUpdate) {
      Navigator.of(context).pop();
    }
  }
}
