import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';

import '../../config.dart';
import 'app_download_logic.dart';

class AppDownloadPage extends StatefulWidget {
  const AppDownloadPage({super.key});

  @override
  State<AppDownloadPage> createState() => _AppDownloadPageState();
}

class _AppDownloadPageState extends State<AppDownloadPage> {
  final AppDownloadLogic logic = Get.find<AppDownloadLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('软件下载列表')),
      body: GetBuilder<AppDownloadLogic>(
        id: 'downInfos',
        builder: (logic) {
          List<DownInfo>? downInfos = logic.downInfos;
          if (downInfos == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (downInfos.isEmpty) {
            return const Center(child: Text('暂无下载任务'));
          }
          return Padding(
            padding: const EdgeInsets.all(3.0),
            child: ListView.builder(
              itemCount: downInfos.length,
              itemBuilder: (context, index) {
                final dowInfo = logic.downInfos?[index];
                if (dowInfo == null) return const SizedBox.shrink();
                return buildItem(dowInfo);
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildItem(DownInfo dowInfo) {
    return GetBuilder<AppDownloadLogic>(
      id: '${dowInfo.appId}',
      builder: (logic) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              // 上半部分：图标、名称、操作按钮
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // 应用图标
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: CachedNetworkImage(
                          imageUrl: dowInfo.appIcon ?? '',
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) => Container(
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.apps,
                                  color: Colors.grey,
                                ),
                              ),
                          errorWidget:
                              (context, url, error) => Container(
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.error,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // 应用名称
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dowInfo.appName ?? '未知文件',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getStatusText(dowInfo.status),
                            style: TextStyle(
                              fontSize: 12.0,
                              color: _getStatusColor(dowInfo.status),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 操作按钮组
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildStatusButton(dowInfo, logic),
                        const SizedBox(width: 8),
                        _buildCancelButton(dowInfo, logic),
                      ],
                    ),
                  ],
                ),
              ),

              // 下半部分：进度条和大小信息
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                child: Column(
                  children: [
                    // 进度条
                    LinearProgressIndicator(
                      value:
                          dowInfo.progress != null
                              ? dowInfo.progress! / 100.0
                              : 0.0,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getStatusColor(dowInfo.status),
                      ),
                      minHeight: 4,
                    ),
                    const SizedBox(height: 8),

                    // 进度信息
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${dowInfo.progress ?? 0}%',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black.withAlpha(180),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${calculateDownloadedSize(dowInfo.appSize ?? '', dowInfo.progress ?? 0)} '
                          '/ ${dowInfo.appSize ?? '未知大小'}',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black.withAlpha(180),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getStatusText(DownloadTaskStatus? status) {
    switch (status) {
      case DownloadTaskStatus.enqueued:
        return '等待中';
      case DownloadTaskStatus.running:
        return '下载中';
      case DownloadTaskStatus.paused:
        return '已暂停';
      case DownloadTaskStatus.failed:
        return '下载失败';
      case DownloadTaskStatus.complete:
        return '下载完成';
      default:
        return '未知状态';
    }
  }

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

  Widget _buildStatusButton(DownInfo dowInfo, AppDownloadLogic logic) {
    switch (dowInfo.status) {
      case DownloadTaskStatus.enqueued:
        return Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.hourglass_empty,
            size: 18,
            color: Colors.grey,
          ),
        );

      case DownloadTaskStatus.running:
        return InkWell(
          onTap: () => logic.pauseDownload(dowInfo),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withAlpha(10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.pause, size: 18),
          ),
        );

      case DownloadTaskStatus.paused:
        return InkWell(
          onTap: () => logic.resumeDownload(dowInfo),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withAlpha(10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.play_arrow, size: 18),
          ),
        );

      case DownloadTaskStatus.failed:
        return InkWell(
          onTap: () => logic.retryDownload(dowInfo),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withAlpha(10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.refresh, size: 18, color: Colors.red),
          ),
        );

      case DownloadTaskStatus.complete:
        return InkWell(
          onTap: () => logic.openDownloadFile(dowInfo),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withAlpha(10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.install_mobile, size: 18),
          ),
        );

      default:
        return const SizedBox(width: 32, height: 32);
    }
  }

  Widget _buildCancelButton(DownInfo dowInfo, AppDownloadLogic logic) {
    return InkWell(
      onTap: () => logic.cancelDownload(dowInfo),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.close, size: 18),
      ),
    );
  }
}
