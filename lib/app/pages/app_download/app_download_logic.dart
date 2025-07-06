import 'dart:async';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_softlib/app/database/database.dart' as db;
import 'package:flutter_softlib/app/database/tables/download_task_table.dart';
import 'package:get/get.dart';

import '../../utils/toast_util.dart';

///下载信息类
class DownInfo {
  String? taskId;
  int? progress;
  String? appId;
  String? appName;
  String? appSize;
  String? appIcon;
  DownloadTaskStatus? status;
  String? createTime;
}

class AppDownloadLogic extends GetxController {
  db.AppDatabase appDatabase = Get.find<db.AppDatabase>();
  late DownloadTaskDao downloadTaskDao;
  List<DownInfo>? downInfos;
  Timer? timer;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    downloadTaskDao = DownloadTaskDao(appDatabase);
    // 获取所有下载任务信息
    getAllDownInfos();
    // 定时器每100毫秒查询一次下载任务状态
    timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      getAllDownInfos();
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    if (timer != null) {
      timer?.cancel();
    }
  }

  ///查询所有下载任务
  Future<void> getAllDownInfos() async {
    List<DownloadTask>? downloadTasks = await FlutterDownloader.loadTasks();
    if (downloadTasks != null) {
      downInfos ??= [];
      downInfos!.clear();
      for (var task in downloadTasks) {
        db.DownloadTask? downloadTaskDb = await downloadTaskDao
            .queryDownloadTaskByTaskId(task.taskId);
        downInfos!.add(
          DownInfo()
            ..taskId = task.taskId
            ..status = task.status
            ..progress = task.progress
            ..appId = downloadTaskDb?.appId
            ..appName = downloadTaskDb?.appName
            ..appSize = downloadTaskDb?.appSize
            ..appIcon = downloadTaskDb?.appIcon
            ..createTime = downloadTaskDb?.createTime.toString(),
        );
      }
      // ✅ 添加排序：根据 status 排序
      const statusOrder = {
        DownloadTaskStatus.running: 0,
        DownloadTaskStatus.enqueued: 1,
        DownloadTaskStatus.paused: 2,
        DownloadTaskStatus.complete: 3,
        DownloadTaskStatus.failed: 4,
        DownloadTaskStatus.canceled: 5,
        DownloadTaskStatus.undefined: 6,
      };
      downInfos!.sort((a, b) {
        final aOrder = statusOrder[a.status] ?? 99;
        final bOrder = statusOrder[b.status] ?? 99;
        return aOrder.compareTo(bOrder);
      });
    }

    update(['downInfos']);
  }

  ///暂停下载
  Future<void> pauseDownload(DownInfo? dowInfo) async {
    String? taskId = dowInfo?.taskId;
    if (taskId == null || taskId.isEmpty) {
      ToastUtil.error('下载任务ID无效，请稍后重试');
      return;
    }
    await FlutterDownloader.pause(taskId: taskId);
    update(['${dowInfo?.appId}']);
  }

  ///恢复下载
  Future<void> resumeDownload(DownInfo? dowInfo) async {
    String? taskId = dowInfo?.taskId;
    if (taskId == null || taskId.isEmpty) {
      ToastUtil.error('下载任务ID无效，请稍后重试');
      return;
    }
    String? taskIdTemp = await FlutterDownloader.resume(taskId: taskId);
    if (taskIdTemp == null) {
      ToastUtil.error('恢复下载失败，请稍后重试');
      return;
    }
    taskId = taskIdTemp;
    downloadTaskDao.updateDownloadTask(
      appId: dowInfo!.appId!,
      taskId: taskId,
      appSize: dowInfo.appSize!,
      appName: dowInfo.appName!,
      appIcon: dowInfo.appIcon!,
    );
    update(['${dowInfo.appId}']);
  }

  ///重试下载
  Future<void> retryDownload(DownInfo? dowInfo) async {
    String? taskId = dowInfo?.taskId;
    if (taskId == null || taskId.isEmpty) {
      ToastUtil.error('下载任务ID无效，请稍后重试');
      return;
    }
    String? taskIdTemp = await FlutterDownloader.retry(taskId: taskId);
    if (taskIdTemp == null) {
      ToastUtil.error('重试下载失败，请稍后重试');
      return;
    }
    taskId = taskIdTemp;
    downloadTaskDao.updateDownloadTask(
      appId: dowInfo!.appId!,
      taskId: taskId,
      appSize: dowInfo.appSize!,
      appName: dowInfo.appName!,
      appIcon: dowInfo.appIcon!,
    );
    update(['${dowInfo.appId}']);
  }

  ///取消下载
  Future<void> cancelDownload(DownInfo? dowInfo) async {
    String? taskId = dowInfo?.taskId;
    String? appId = dowInfo?.appId;
    if (taskId == null || taskId.isEmpty) {
      ToastUtil.error('下载任务ID无效，请稍后重试');
      return;
    }
    await FlutterDownloader.remove(taskId: taskId, shouldDeleteContent: true);
    downloadTaskDao.deleteDownloadTask(appId!);
    downInfos?.removeWhere((element) => element.taskId == taskId);
    update(['downInfos']);
  }

  ///打开下载的软件
  Future<void> openDownloadFile(DownInfo? dowInfo) async {
    String? taskId = dowInfo?.taskId;
    if (taskId == null || taskId.isEmpty) {
      ToastUtil.error('下载任务ID无效，请稍后重试');
      return;
    }
    bool results = await FlutterDownloader.open(taskId: taskId);
    if (!results) {
      ToastUtil.error('打开下载的软件失败，请稍后重试');
    }
  }
}
