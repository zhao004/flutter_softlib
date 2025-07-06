import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// 处理常用应用权限的工具类。
class PermissionUtils {
  /// 请求应用所需的所有权限。
  ///
  /// 此方法处理：
  /// - Android 13+ 媒体权限（图片、视频）
  /// - Android 12 及以下存储权限
  /// - 通知权限
  /// - 安装包权限（用于APK安装）
  ///
  /// 它会检查每个权限的当前状态并在未授权时请求它们。
  /// 如果权限被永久拒绝，将提示用户打开应用设置。
  static Future<void> requestAppPermissions(BuildContext context) async {
    // 媒体/存储权限
    await _requestMediaAndStoragePermissions(context);

    // 通知权限
    await _requestNotificationPermission(context);

    // 安装包权限
    // await _requestInstallPackagesPermission(context);
  }

  static Future<void> _requestMediaAndStoragePermissions(
    BuildContext context,
  ) async {
    // 在 Android 13+上，优先使用照片、视频权限。
    // 在 Android 12 及以下版本，使用存储权限。
    final List<Permission> mediaPermissions = [
      Permission.photos,
      Permission.videos,
    ];

    Map<Permission, PermissionStatus> statuses =
        await mediaPermissions.request();

    // 检查各项媒体权限
    bool allMediaGranted = true;
    String deniedMediaPermissions = '';

    if (statuses[Permission.photos] != PermissionStatus.granted) {
      allMediaGranted = false;
      deniedMediaPermissions += '图片, ';
    }
    if (statuses[Permission.videos] != PermissionStatus.granted) {
      allMediaGranted = false;
      deniedMediaPermissions += '视频, ';
    }

    if (!allMediaGranted) {
      // 删除尾部的逗号和空格
      deniedMediaPermissions = deniedMediaPermissions.substring(
        0,
        deniedMediaPermissions.length - 2,
      );
      _handlePermissionDenial(
        context,
        '媒体权限 ($deniedMediaPermissions)',
        statuses,
      );
    }

    // 针对旧版Android或需要更广泛存储访问的情况
    // (虽然在新版Android上，上述权限通常足够满足典型的媒体访问需求)
    final storageStatus = await Permission.storage.status;
    if (storageStatus != PermissionStatus.granted) {
      final newStorageStatus = await Permission.storage.request();
      if (newStorageStatus != PermissionStatus.granted) {
        _handlePermissionDenial(context, '旧版存储权限', {
          Permission.storage: newStorageStatus,
        });
      }
    }
  }

  static Future<void> _requestNotificationPermission(
    BuildContext context,
  ) async {
    final status = await Permission.notification.status;
    if (status != PermissionStatus.granted) {
      final newStatus = await Permission.notification.request();
      if (newStatus != PermissionStatus.granted) {
        _handlePermissionDenial(context, '通知权限', {
          Permission.notification: newStatus,
        });
      }
    }
  }

  // static Future<void> _requestInstallPackagesPermission(
  //   BuildContext context,
  // ) async {
  //   final status = await Permission.requestInstallPackages.status;
  //   if (status != PermissionStatus.granted) {
  //     final newStatus = await Permission.requestInstallPackages.request();
  //     if (newStatus != PermissionStatus.granted) {
  //       _handlePermissionDenial(context, '安装包权限', {
  //         Permission.requestInstallPackages: newStatus,
  //       });
  //     }
  //   }
  // }

  /// 处理权限被拒绝的情况，尤其是永久拒绝。
  static void _handlePermissionDenial(
    BuildContext context,
    String permissionName,
    Map<Permission, PermissionStatus> statuses,
  ) {
    bool permanentlyDenied = false;
    statuses.forEach((permission, status) {
      if (status.isPermanentlyDenied) {
        permanentlyDenied = true;
      }
    });

    if (permanentlyDenied) {
      _showSettingsDialog(context, '$permissionName 已被永久拒绝。请在应用设置中启用它们。');
    }
  }

  /// 显示提示用户打开应用设置的对话框。
  static void _showSettingsDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('需要权限'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('打开设置'),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings(); // 打开应用的设置界面
              },
            ),
          ],
        );
      },
    );
  }
}
