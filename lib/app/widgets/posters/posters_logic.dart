import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_softlib/app/utils/toast_util.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

import '../../config.dart';

class PostersLogic extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  /// 保存海报到相册
  Future<void> savePosterToGallery(
    BuildContext context,
    GlobalKey repaintKey,
  ) async {
    try {
      if (repaintKey.currentContext == null ||
          !repaintKey.currentContext!.findRenderObject()!.attached) {
        ToastUtil.error('无法获取海报内容，请重试');
        return;
      }
      final boundary =
          repaintKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      ui.Image? image;
      try {
        image = await boundary.toImage(pixelRatio: 3.0);
      } catch (e) {
        ToastUtil.error('生成海报图片失败，请重试');
        logger.e('toImage error: ${e.toString()}');
        return;
      }

      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) {
        ToastUtil.error('图片数据处理失败，请重试');
        return;
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      final fileName = "poster_${DateTime.now().millisecondsSinceEpoch}";
      final result = await ImageGallerySaverPlus.saveImage(
        pngBytes,
        quality: 100,
        name: fileName,
      );

      if (result != null && result['isSuccess'] == true) {
        ToastUtil.success('海报已保存至相册');
      } else {
        final errorMsg =
            result != null && result['errorMessage'] != null
                ? '保存失败: ${result['errorMessage']}'
                : '保存失败，请重试';
        ToastUtil.error(errorMsg);
        logger.e('Save poster failed: $result');
      }
    } catch (e) {
      logger.e('Save poster exception: ${e.toString()}');
      ToastUtil.error('保存海报失败，请重试');
    }
  }

  ///删除字符串里面的空行
  String removeEmptyLines(String input) {
    return input.split('\n').where((line) => line.trim().isNotEmpty).join('\n');
  }
}
