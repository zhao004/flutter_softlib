import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_softlib/generated/assets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../config.dart';
import '../../models/http/results/lzy_file_info_model.dart';
import '../../utils/jump_util.dart';
import 'app_details_logic.dart';

class AppDetailsPage extends StatefulWidget {
  const AppDetailsPage({super.key});

  @override
  State<AppDetailsPage> createState() => _AppDetailsPageState();
}

class _AppDetailsPageState extends State<AppDetailsPage> {
  final AppDetailsLogic logic = Get.find<AppDetailsLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('软件详情'),
        actionsPadding: EdgeInsets.only(right: 5),
        actions: [
          //浏览器图标
          IconButton(
            icon: Icon(FontAwesomeIcons.chrome),
            onPressed: () => JumpUtil.openUrl(logic.dowUrl ?? ''),
          ),
          GetBuilder<AppDetailsLogic>(
            id: 'share',
            builder: (logic) {
              LzyFileInfoData? appInfo = logic.appInfo;
              if (appInfo == null) {
                return SizedBox.shrink();
              }
              return IconButton(
                icon: Icon(Icons.share),
                onPressed: () => logic.showSharePopUps(context),
              );
            },
          ),
        ],
      ),
      body: GetBuilder<AppDetailsLogic>(
        id: 'appInfo',
        builder: (logic) {
          LzyFileInfoData? appInfo = logic.appInfo;
          if (logic.msgError != null && logic.msgError!.isNotEmpty) {
            return Center(
              child: Text(
                logic.msgError!,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }
          if (appInfo == null) {
            return Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                // 软件头部
                _buildAppHeader(appInfo),
                // 软件详情
                _buildAppDetails(appInfo),
                // 软件示例图
                _buildAppScreenshots(appInfo),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: buildBottom(context),
    );
  }

  /// 构建软件头部
  Widget _buildAppHeader(LzyFileInfoData appInfo) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Get.theme.primaryColor.withValues(alpha: 0.6),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      margin: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: ListTile(
        horizontalTitleGap: 18,
        visualDensity: VisualDensity(vertical: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: appInfo.fileIcon ?? '',
            width: 60,
            height: 60,
            fit: BoxFit.contain,
            placeholder: (context, url) => appIcon(60, 60),
            errorWidget: (context, url, error) => appIcon(60, 60),
          ),
        ),
        title: Text(
          appInfo.fileName ?? '未知软件',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Wrap(
            spacing: 8,
            runSpacing: 5,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                decoration: BoxDecoration(
                  color: Get.theme.primaryColor.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  appInfo.fileSize ?? '未知大小',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.black
                            : Colors.white,
                  ),
                ),
              ),
              if (appInfo.fileTime != null && appInfo.fileTime!.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  decoration: BoxDecoration(
                    color: Get.theme.primaryColor.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    appInfo.fileTime ?? '未知时间',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.black
                              : Colors.white,
                    ),
                  ),
                ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                decoration: BoxDecoration(
                  color: Get.theme.primaryColor.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  appInfo.fileType ?? '未知类型',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.black
                            : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建软件详情
  Widget _buildAppDetails(LzyFileInfoData appInfo) {
    String? fileDesc = appInfo.fileDesc;
    if (fileDesc == null || fileDesc.isEmpty) {
      return SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: ListTile(
        minVerticalPadding: 10,
        contentPadding: EdgeInsets.all(0),
        title: Text(
          '软件介绍',
          style: Get.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            appInfo.fileDesc ?? '',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[500]
                      : Colors.grey[800],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建软件示例图
  Widget _buildAppScreenshots(LzyFileInfoData appInfo) {
    String? fileImage = appInfo.fileImage;
    if (fileImage == null || fileImage.isEmpty) {
      return SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text(
          '软件截图',
          style: Get.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: GestureDetector(
          onTap: () => logic.showPreviewImage(appInfo.fileImage ?? ''),
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: Get.height * 0.3,
                child: CachedNetworkImage(
                  imageUrl: fileImage,
                  fit: BoxFit.contain,
                  placeholder:
                      (context, url) =>
                          Image.asset(Assets.imagesSucceed, fit: BoxFit.cover),
                  errorWidget:
                      (context, url, error) =>
                          Image.asset(Assets.imagesSucceed, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 构建底部下载按钮
  Widget buildBottom(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(1),
            offset: const Offset(0, -1),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        child: GetBuilder<AppDetailsLogic>(
          id: 'download',
          builder: (download) {
            DownloadTask? downloadTask = download.downloadTask;
            // 没有下载任务
            if (downloadTask == null) {
              return _buildDownloadButton(download);
            }
            // 下载完成
            if (downloadTask.status == DownloadTaskStatus.complete) {
              return _buildInstallButton(download);
            }
            // 下载中状态
            return _buildDownloadingProgress(context, downloadTask, download);
          },
        ),
      ),
    );
  }

  /// 构建下载按钮
  Widget _buildDownloadButton(AppDetailsLogic download) {
    return SizedBox(
      height: 50,
      child: FilledButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        onPressed:
            () => download.addDownload(
              logic.appInfo?.fileName ?? '未知文件名',
              logic.dowUrl,
            ),
        child: const Text(
          '下载软件',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  /// 构建安装按钮
  Widget _buildInstallButton(AppDetailsLogic download) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        onPressed: () => download.openDownloadFile(),
        style: FilledButton.styleFrom(backgroundColor: Colors.green),
        child: const Text(
          '安装软件',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  /// 构建下载进度UI
  Widget _buildDownloadingProgress(
    BuildContext context,
    DownloadTask downloadTask,
    AppDetailsLogic download,
  ) {
    return Column(
      spacing: 12,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 进度条
        Row(
          spacing: 12,
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: downloadTask.progress / 100,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getStatusColor(downloadTask.status),
                ),
                minHeight: 6,
              ),
            ),
            Text(
              '${downloadTask.progress}%',

              style: Get.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade500
                        : Colors.black87,
              ),
            ),
          ],
        ),
        // 状态信息和操作按钮
        Row(
          children: [
            // 状态信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getStatusText(downloadTask.status),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _getStatusColor(downloadTask.status),
                    ),
                  ),
                  Text(
                    '${calculateDownloadedSize(logic.appSize, downloadTask.progress)} / ${logic.appSize}',
                    style: Get.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade500
                              : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            // 操作按钮
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildActionButton(downloadTask, download),
                const SizedBox(width: 8),
                _buildCancelButton(download),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// 构建操作按钮
  Widget _buildActionButton(
    DownloadTask downloadTask,
    AppDetailsLogic download,
  ) {
    switch (downloadTask.status) {
      case DownloadTaskStatus.enqueued:
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade900
                    : Colors.black12,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.hourglass_empty, size: 20),
        );
      case DownloadTaskStatus.running:
        return InkWell(
          onTap: () => download.pauseDownload(),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade900
                      : Colors.black12,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.pause, size: 20),
          ),
        );
      case DownloadTaskStatus.paused:
        return InkWell(
          onTap: () => download.resumeDownload(),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade900
                      : Colors.black12,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.play_arrow, size: 20),
          ),
        );
      case DownloadTaskStatus.failed:
        return InkWell(
          onTap: () => download.retryDownload(),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade900
                      : Colors.black12,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.refresh, size: 20),
          ),
        );
      default:
        return const SizedBox();
    }
  }

  /// 构建取消按钮
  Widget _buildCancelButton(AppDetailsLogic download) {
    return InkWell(
      onTap: () => download.cancelDownload(),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade900
                  : Colors.black12,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.close, size: 20),
      ),
    );
  }

  /// 获取状态文本
  String _getStatusText(DownloadTaskStatus status) {
    switch (status) {
      case DownloadTaskStatus.enqueued:
        return '等待下载';
      case DownloadTaskStatus.running:
        return '正在下载';
      case DownloadTaskStatus.paused:
        return '已暂停';
      case DownloadTaskStatus.failed:
        return '下载失败';
      default:
        return '未知状态';
    }
  }

  /// 获取状态颜色
  Color _getStatusColor(DownloadTaskStatus? status) {
    switch (status) {
      case DownloadTaskStatus.enqueued:
        return Colors.grey;
      case DownloadTaskStatus.running:
        return Theme.of(context).primaryColor;
      case DownloadTaskStatus.paused:
        return Colors.orange;
      case DownloadTaskStatus.failed:
        return Colors.red;
      case DownloadTaskStatus.complete:
        return Theme.of(context).primaryColor;
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    Get.delete<AppDetailsLogic>();
    super.dispose();
  }
}
