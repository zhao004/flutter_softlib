import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/jump_util.dart';

class ArticleReadingLogic extends GetxController {
  // 统一的颜色样式
  static const String primaryColor = '#3498db';
  static const String darkColor = '#2c3e50';
  static const String grayColor = '#7f8c8d';
  static const String lightGrayColor = '#95a5a6';
  static const String backgroundColor = '#f8f9fa';
  static const String borderColor = '#e1e4e8';
  static const String codeBackgroundColor = '#f6f8fa';
  static const String codeTextColor = '#24292e';
  static const String inlineCodeBackgroundColor = '#f1f3f4';
  static const String inlineCodeTextColor = '#d73a49';

  // 基础数据
  late final String title;
  late final String content;

  // 控制器
  final ScrollController scrollController = ScrollController();
  final PageController imagePageController = PageController();

  // 图片预览相关
  List<String> imageUrls = [];
  int currentImageIndex = 0;
  bool isImagePreviewVisible = false;

  @override
  void onInit() {
    super.onInit();
    _initializeArguments();
    _extractImageUrls();
  }

  /// 初始化参数
  void _initializeArguments() {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    title = args['title'] ?? '文章阅读';
    content = args['content'] ?? '文章内容';
  }

  /// 提取HTML中的图片URL
  void _extractImageUrls() {
    final RegExp imgRegex = RegExp(
      r'<img[^>]+src="([^"]+)"[^>]*>',
      caseSensitive: false,
    );
    final matches = imgRegex.allMatches(content);

    imageUrls = matches.map((match) => match.group(1)!).toList();
  }

  /// 显示图片预览
  void showImagePreview(String imageUrl) {
    final index = imageUrls.indexOf(imageUrl);
    if (index != -1) {
      currentImageIndex = index;
      isImagePreviewVisible = true;

      // 先更新UI显示预览界面
      update(['imagePreview']);

      // 等待UI更新完成后再设置页面
      Future.delayed(const Duration(milliseconds: 50), () {
        if (imagePageController.hasClients) {
          imagePageController.jumpToPage(index);
        }
      });
    }
  }

  /// 隐藏图片预览
  void hideImagePreview() {
    isImagePreviewVisible = false;
    update(['imagePreview']);
  }

  /// 切换到下一张图片
  void nextImage() {
    if (currentImageIndex < imageUrls.length - 1) {
      currentImageIndex++;
      if (imagePageController.hasClients) {
        imagePageController.animateToPage(
          currentImageIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  /// 切换到上一张图片
  void previousImage() {
    if (currentImageIndex > 0) {
      currentImageIndex--;
      if (imagePageController.hasClients) {
        imagePageController.animateToPage(
          currentImageIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  /// 图片页面改变时的回调
  void onImagePageChanged(int index) {
    currentImageIndex = index;
    update(['imagePreview']);
  }

  /// 滚动到顶部
  void scrollToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  /// 处理链接点击
  Future<bool> handleLinkTap(String url) async {
    try {
      JumpUtil.openUrl(url);
      return true;
    } catch (e) {
      try {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          return true;
        }
      } catch (e2) {
        Get.snackbar(
          '链接错误',
          '无法打开链接: $url',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
    return false;
  }

  /// 处理图片点击
  void handleImageTap(String imageUrl) {
    showImagePreview(imageUrl);
  }

  /// 构建图片错误组件
  Widget buildImageError() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.broken_image, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              '图片加载失败',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  /// 获取自定义样式
  Map<String, String>? getCustomStyles(String elementName) {
    switch (elementName) {
      case 'body':
        return {'margin': '0', 'padding': '0'};
      case 'img':
        return {
          'max-width': '100%',
          'height': 'auto',
          'border-radius': '8px',
          'margin': '12px 0',
          'box-shadow': '0 2px 8px rgba(0,0,0,0.1)',
          'cursor': 'pointer',
        };
      case 'video':
        return {'max-width': '100%', 'height': 'auto', 'border-radius': '8px'};
      case 'h1':
        return {
          'font-size': '2.2em',
          'font-weight': '700',
          'color': darkColor,
          'margin': '24px 0 16px 0',
          'line-height': '1.3',
          'display': 'table',
          'border-bottom': '4px solid $primaryColor',
          'padding-bottom': '8px',
        };
      case 'h2':
        return {
          'font-size': '1.8em',
          'font-weight': '600',
          'color': darkColor,
          'margin': '20px 0 14px 0',
          'line-height': '1.4',
          'display': 'table',
          'border-bottom': '4px solid $primaryColor',
          'padding-bottom': '8px',
        };
      case 'h3':
        return {
          'font-size': '1.5em',
          'font-weight': '600',
          'color': darkColor,
          'margin': '18px 0 12px 0',
          'line-height': '1.4',
          'display': 'table',
          'border-bottom': '4px solid $primaryColor',
          'padding-bottom': '8px',
        };
      case 'h4':
        return {
          'font-size': '1.3em',
          'font-weight': '600',
          'color': darkColor,
          'margin': '16px 0 10px 0',
          'line-height': '1.5',
          'display': 'table',
          'border-bottom': '4px solid $primaryColor',
          'padding-bottom': '8px',
        };
      case 'h5':
        return {
          'font-size': '1.1em',
          'font-weight': '600',
          'color': darkColor,
          'margin': '14px 0 8px 0',
          'line-height': '1.5',
          'display': 'table',
          'border-bottom': '4px solid $primaryColor',
          'padding-bottom': '8px',
        };
      case 'h6':
        return {
          'font-size': '1em',
          'font-weight': '600',
          'color': grayColor,
          'margin': '12px 0 6px 0',
          'line-height': '1.5',
          'text-transform': 'uppercase',
          'letter-spacing': '0.5px',
          'display': 'table',
          'border-bottom': '4px solid $primaryColor',
          'padding-bottom': '8px',
        };
      case 'blockquote':
        return {
          'margin': '16px 0',
          'padding': '16px 20px',
          'background-color': backgroundColor,
          'border-left': '4px solid $primaryColor',
          'border-radius': '6px',
          'font-style': 'italic',
          'color': darkColor,
          'box-shadow': '0 2px 4px rgba(0,0,0,0.05)',
        };
      case 'cite':
        return {
          'font-style': 'italic',
          'color': lightGrayColor,
          'font-size': '0.9em',
        };
      case 'q':
        return {
          'font-style': 'italic',
          'color': darkColor,
          'quotes': '"\\201C" "\\201D" "\\2018" "\\2019"',
        };
      case 'code':
        return {
          'background-color': inlineCodeBackgroundColor,
          'color': inlineCodeTextColor,
          'padding': '2px 6px',
          'border-radius': '4px',
          'font-family': 'monospace',
          'font-size': '0.9em',
          'font-weight': '500',
        };
      case 'pre':
        return {
          'background-color': codeBackgroundColor,
          'color': codeTextColor,
          'padding': '16px',
          'border-radius': '8px',
          'border': '1px solid $borderColor',
          'overflow-x': 'auto',
          'font-family': 'monospace',
          'font-size': '0.85em',
          'line-height': '1.45',
          'margin': '16px 0',
        };
      case 'kbd':
        return {
          'background-color': backgroundColor,
          'color': darkColor,
          'padding': '2px 6px',
          'border': '1px solid $borderColor',
          'border-radius': '4px',
          'box-shadow': 'inset 0 -1px 0 $borderColor',
          'font-family': 'monospace',
          'font-size': '0.85em',
          'font-weight': '600',
        };
      case 'samp':
        return {
          'background-color': codeBackgroundColor,
          'color': grayColor,
          'padding': '2px 6px',
          'border-radius': '4px',
          'font-family': 'monospace',
          'font-size': '0.9em',
        };
      case 'var':
        return {
          'color': '#e36209',
          'font-style': 'italic',
          'font-family': 'monospace',
          'font-weight': '500',
        };
      default:
        return null;
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    imagePageController.dispose();
    super.onClose();
  }
}
