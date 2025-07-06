import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_softlib/app/http/http_api.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';

import '../../config.dart';
import '../../database/database.dart' as db;
import '../../database/tables/download_task_table.dart';
import '../../models/http/results/lzy_file_info_model.dart';
import '../../models/http/results/lzy_file_parse_model.dart';
import '../../utils/toast_util.dart';
import '../../widgets/posters/posters_widget.dart';

@pragma('vm:entry-point')
class AppDetailsLogic extends GetxController {
  String appId = Get.arguments['appId'];
  String dowUrl = Get.arguments['dowUrl'];
  String appSize = Get.arguments['appSize'];

  HttpApi httpApi = Get.find<HttpApi>();
  GlobalKey posterKey = GlobalKey();
  LzyFileInfoData? appInfo;
  String? msgError;

  db.AppDatabase appDatabase = Get.find<db.AppDatabase>();
  ReceivePort port = ReceivePort();
  late DownloadTaskDao downloadTaskDao;
  DownloadTask? downloadTask;
  String? taskId;

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName(
      'app_details_downloader_send_port',
    );
    send?.send([id, status, progress]);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    downloadTaskDao = DownloadTaskDao(appDatabase);
    getAppInfo();
    // 获取任务信息
    getTaskInfo();
    // 清理旧的端口映射
    IsolateNameServer.removePortNameMapping('app_details_downloader_send_port');
    // 注册新的端口
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      'app_details_downloader_send_port',
    );
    // 监听下载进度
    port.listen((dynamic data) {
      if (data is List && data.length >= 3) {
        getTaskInfo();
      }
    });
    // 注册回调函数到Flutter Downloader
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    IsolateNameServer.removePortNameMapping('app_details_downloader_send_port');
  }

  /// 获取软件信息
  void getAppInfo() async {
    try {
      LzyFileInfoModel lzyFileInfo = await httpApi.getLzyFileInfo(dowUrl);
      if (lzyFileInfo.code != 1) {
        msgError = lzyFileInfo.msg ?? '获取软件信息失败';
        return;
      }
      appInfo = lzyFileInfo.data;
      update(['appInfo', 'share', 'download']);
    } catch (e) {
      logger.e(e.toString());
    } finally {
      update(['appInfo', 'share', 'download']);
    }
  }

  ///获取任务信息
  Future<void> getTaskInfo() async {
    String? taskIdTemp = await downloadTaskDao.queryDownloadTaskByAppId(appId);
    taskId = taskIdTemp;
    if (taskId != null && taskId!.isNotEmpty) {
      List<DownloadTask>? tasks = await FlutterDownloader.loadTasksWithRawQuery(
        query: "SELECT * FROM task WHERE task_id='$taskId'",
      );
      if (tasks != null && tasks.isNotEmpty) {
        downloadTask = tasks.first;
      } else {
        downloadTask = null;
      }
    }
    update(['download']);
  }

  ///添加下载
  Future<void> addDownload(String fileName, String url) async {
    String? parseUrl;
    // 检查通知权限
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
    try {
      LzyFileParseModel results = await httpApi.getLzyFileParse(url);
      if (results.code != 1) {
        ToastUtil.error(results.msg ?? '解析失败');
        return;
      }
      parseUrl = results.data?.url;
    } catch (e) {
      logger.e(e.toString());
    }
    if (parseUrl == null || parseUrl.isEmpty) {
      ToastUtil.error('下载链接无效，请稍后重试');
      return;
    }
    fileName = fileName.trim();
    fileName = fileName.replaceAll(' ', '_');
    if (fileName.endsWith('.apk')) {
      fileName = fileName.substring(0, fileName.length - 4);
      fileName += '_${DateTime.now().millisecondsSinceEpoch}.apk';
    }
    final taskId = await FlutterDownloader.enqueue(
      url: parseUrl,
      fileName: fileName,
      savedDir: '/storage/emulated/0/Download',
      showNotification: true,
      saveInPublicStorage: true,
      openFileFromNotification: true,
    );
    if (taskId == null) {
      ToastUtil.error('下载失败，请稍后重试');
      return;
    }
    downloadTaskDao.setDownloadTask(
      taskId: taskId,
      appId: appId,
      appIcon: appInfo!.fileIcon!,
      appName: appInfo!.fileName!,
      appSize: appInfo!.fileSize!,
    );
    getTaskInfo();
  }

  ///暂停下载
  Future<void> pauseDownload() async {
    if (taskId == null || taskId!.isEmpty) {
      ToastUtil.error('下载任务ID无效，请稍后重试');
      return;
    }
    await FlutterDownloader.pause(taskId: taskId!);
    update(['download']);
  }

  ///恢复下载
  Future<void> resumeDownload() async {
    if (taskId == null || taskId!.isEmpty) {
      ToastUtil.error('下载任务ID无效，请稍后重试');
      return;
    }
    String? taskIdTemp = await FlutterDownloader.resume(taskId: taskId!);
    if (taskIdTemp == null) {
      ToastUtil.error('恢复下载失败，请稍后重试');
      return;
    }
    taskId = taskIdTemp;
    downloadTaskDao.updateDownloadTask(
      appId: appId,
      taskId: taskId!,
      appIcon: appInfo!.fileIcon!,
      appName: appInfo!.fileName!,
      appSize: appInfo!.fileSize!,
    );
    update(['download']);
  }

  ///重试下载
  Future<void> retryDownload() async {
    if (taskId == null || taskId!.isEmpty) {
      ToastUtil.error('下载任务ID无效，请稍后重试');
      return;
    }
    String? taskIdTemp = await FlutterDownloader.retry(taskId: taskId!);
    if (taskIdTemp == null) {
      ToastUtil.error('重试下载失败，请稍后重试');
      return;
    }
    taskId = taskIdTemp;
    downloadTaskDao.updateDownloadTask(
      appId: appId,
      taskId: taskId!,
      appIcon: appInfo!.fileIcon!,
      appName: appInfo!.fileName!,
      appSize: appInfo!.fileSize!,
    );
    update(['download']);
  }

  ///取消下载
  Future<void> cancelDownload() async {
    if (taskId == null || taskId!.isEmpty) {
      ToastUtil.error('下载任务ID无效，请稍后重试');
      return;
    }
    await FlutterDownloader.remove(taskId: taskId!, shouldDeleteContent: true);
    downloadTaskDao.deleteDownloadTask(appId);
    taskId = null;
    downloadTask = null;
    update(['download']);
  }

  ///打开下载的软件
  Future<void> openDownloadFile() async {
    if (taskId == null || taskId!.isEmpty) {
      ToastUtil.error('下载任务ID无效，请稍后重试');
      return;
    }
    bool results = await FlutterDownloader.open(taskId: taskId!);
    if (!results) {
      ToastUtil.error('打开下载的软件失败，请稍后重试');
    }
  }

  /// 打开分享弹窗
  void showSharePopUps(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => PostersWidget(appInfo: appInfo, dowUrl: dowUrl),
    );
  }

  ///预览图片
  void showPreviewImage(String imageUrl) {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: Get.back,
          child: Center(
            child: PhotoView(
              backgroundDecoration: BoxDecoration(
                color: Colors.black.withAlpha(180),
              ),
              imageProvider: NetworkImage(imageUrl),
            ),
          ),
        );
      },
    );
  }
}
