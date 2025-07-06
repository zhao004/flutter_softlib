import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'article_reading_logic.dart';

class ArticleReadingPage extends StatelessWidget {
  const ArticleReadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(ArticleReadingLogic());

    return Scaffold(
      appBar: AppBar(
        title: Text(logic.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: Stack(
        children: [
          // 文章内容
          SingleChildScrollView(
            controller: logic.scrollController,
            padding: const EdgeInsets.all(16),
            child: HtmlWidget(
              logic.content,
              textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                height: 1.6,
                color: Colors.grey[800],
              ),
              customStylesBuilder: (element) {
                return logic.getCustomStyles(element.localName ?? '');
              },
              onTapUrl: logic.handleLinkTap,
              onTapImage: (imageMetadata) {
                logic.handleImageTap(imageMetadata.sources.first.url);
              },
              onErrorBuilder: (context, element, error) {
                if (element.localName == 'img') {
                  return logic.buildImageError();
                }
                return Text('加载失败: ${element.localName}');
              },
              enableCaching: true,
              renderMode: RenderMode.column,
            ),
          ),

          // 图片预览遮罩
          GetBuilder<ArticleReadingLogic>(
            id: 'imagePreview',
            builder: (logic) {
              if (!logic.isImagePreviewVisible || logic.imageUrls.isEmpty) {
                return const SizedBox.shrink();
              }
              return _buildImagePreview(context, logic);
            },
          ),
        ],
      ),
      floatingActionButton: GetBuilder<ArticleReadingLogic>(
        id: 'imagePreview',
        builder: (logic) {
          if (logic.isImagePreviewVisible) {
            return const SizedBox.shrink();
          }
          return FloatingActionButton(
            onPressed: logic.scrollToTop,
            mini: true,
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(
              Icons.keyboard_arrow_up,
              color: Colors.white,
              size: 28,
            ),
          );
        },
      ),
    );
  }

  /// 构建图片预览组件
  Widget _buildImagePreview(BuildContext context, ArticleReadingLogic logic) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // 图片预览Gallery
          PhotoViewGallery.builder(
            pageController: PageController(initialPage: logic.currentImageIndex),
            itemCount: logic.imageUrls.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(
                  logic.imageUrls[index],
                ),
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 4.0,
                heroAttributes: PhotoViewHeroAttributes(
                  tag: logic.imageUrls[index],
                ),
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.error, color: Colors.white, size: 64),
                  );
                },
              );
            },
            onPageChanged: logic.onImagePageChanged,
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            loadingBuilder: (context, event) {
              if (event == null) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }
              return Center(
                child: CircularProgressIndicator(
                  value:
                      event.cumulativeBytesLoaded /
                      (event.expectedTotalBytes ?? 1),
                  color: Colors.white,
                ),
              );
            },
          ),

          // 关闭按钮
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: GestureDetector(
              onTap: logic.hideImagePreview,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 24),
              ),
            ),
          ),

          // 图片计数器
          if (logic.imageUrls.length > 1)
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${logic.currentImageIndex + 1} / ${logic.imageUrls.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
