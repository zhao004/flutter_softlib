import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

import '../generated/assets.dart';

ThemeMode _currentMode = ThemeMode.system;

bool get isDarkMode {
  if (_currentMode == ThemeMode.system) {
    return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.dark;
  }
  return _currentMode == ThemeMode.dark;
}

/// 键值对数据库
final SharedPreferencesAsync keyValue = SharedPreferencesAsync();

/// Dio 是否启动调试模式
bool isDioDebug = false;

///应用图标
Widget appIcon(double width, double height) {
  return Image.asset(
    Assets.imagesApp,
    fit: BoxFit.cover,
    width: width,
    height: height,
  );
}

/// Dio 日志拦截器
TalkerDioLogger talkerDioLogger = TalkerDioLogger(
  settings: const TalkerDioLoggerSettings(
    printResponseData: true,
    printResponseHeaders: false,
  ),
);

/// 全局日志
final Logger logger = Logger(
  output: ConsoleOutput(),
  printer: PrettyPrinter(
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.dateAndTime,
  ),
);

/// 将单位字符串转为字节（支持 K/M/G，大小写均可）
int _parseSizeToBytes(String sizeStr) {
  final pattern = RegExp(r'^([\d.]+)\s*([kKmMgG])?');
  final match = pattern.firstMatch(sizeStr.trim());
  if (match == null) return 0;

  final numValue = double.tryParse(match.group(1) ?? '0') ?? 0;
  final unit = (match.group(2) ?? '').toLowerCase();

  switch (unit) {
    case 'k':
      return (numValue * 1024).round();
    case 'm':
      return (numValue * 1024 * 1024).round();
    case 'g':
      return (numValue * 1024 * 1024 * 1024).round();
    default:
      return numValue.round(); // 无单位默认字节
  }
}

/// 将字节数转为带单位的字符串（保留一位小数）
String formatBytes(int bytes) {
  if (bytes >= 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}G';
  } else if (bytes >= 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}M';
  } else if (bytes >= 1024) {
    return '${(bytes / 1024).toStringAsFixed(1)}K';
  } else {
    return '${bytes}B';
  }
}

/// 传入总大小字符串和百分比，返回已下载格式化字符串
String calculateDownloadedSize(String totalSizeStr, int percent) {
  final totalBytes = _parseSizeToBytes(totalSizeStr);
  if (percent <= 0 || percent > 100 || totalBytes <= 0) return '0B';

  final downloadedBytes = (totalBytes * percent / 100).round();
  return formatBytes(downloadedBytes);
}
