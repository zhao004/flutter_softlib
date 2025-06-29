import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'article_reading_logic.dart';

class ArticleReadingPage extends StatefulWidget {
  const ArticleReadingPage({super.key});

  @override
  State<ArticleReadingPage> createState() => _ArticleReadingPageState();
}

class _ArticleReadingPageState extends State<ArticleReadingPage> {
  final ArticleReadingLogic logic = Get.find<ArticleReadingLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('文章阅读')),
      body: Center(child: Text('文章阅读')),
    );
  }

  @override
  void dispose() {
    Get.delete<ArticleReadingLogic>();
    super.dispose();
  }
}
