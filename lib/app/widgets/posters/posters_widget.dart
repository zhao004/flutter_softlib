import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../config.dart';
import '../../models/http/results/lzy_file_info_model.dart';
import 'posters_logic.dart';

class PostersWidget extends StatefulWidget {
  final String? dowUrl;
  final LzyFileInfoData? appInfo;

  const PostersWidget({super.key, this.appInfo, this.dowUrl});

  @override
  State<PostersWidget> createState() => _PostersWidgetState();
}

class _PostersWidgetState extends State<PostersWidget> {
  final PostersLogic logic = Get.put(PostersLogic());
  GlobalKey posterKey = GlobalKey();

  LzyFileInfoData? get appInfo => widget.appInfo;

  String? get dowUrl => widget.dowUrl;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          _buildPosterUI(),
          ElevatedButton.icon(
            onPressed: () => logic.savePosterToGallery(context, posterKey),
            icon: const Icon(Icons.save),
            label: const Text('保存海报'),
          ),
          ElevatedButton.icon(
            onPressed: Get.back,
            icon: const Icon(Icons.cancel),
            label: const Text('取消分享'),
          ),
        ],
      ),
    );
  }

  /// 分享海报UI
  Widget _buildPosterUI() {
    return RepaintBoundary(
      key: posterKey,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8), // 柔和背景色
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: appInfo?.fileIcon ?? '',
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                placeholder: (context, url) => appIcon(70, 70),
                errorWidget: (context, url, error) => appIcon(70, 70),
              ),
            ),
            Text(
              appInfo?.fileName ?? '未知软件',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              logic.removeEmptyLines(appInfo?.fileDesc ?? ''),
              textAlign: TextAlign.center,
              maxLines: 8,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: 130,
              height: 130,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: QrImageView(
                data: dowUrl ?? '',
                size: 120,
                gapless: true,
                version: QrVersions.auto,
                backgroundColor: Colors.white,
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.circle,
                  color: Colors.black87,
                ),
                embeddedImageStyle: const QrEmbeddedImageStyle(
                  size: Size(32, 32),
                  color: Colors.transparent,
                ),
              ),
            ),
            const Text(
              '扫码立即下载',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black45,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<PostersLogic>();
    super.dispose();
  }
}
