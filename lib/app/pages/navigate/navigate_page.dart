import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'navigate_logic.dart';

class NavigatePage extends StatefulWidget {
  const NavigatePage({super.key});

  @override
  State<NavigatePage> createState() => _NavigatePageState();
}

class _NavigatePageState extends State<NavigatePage> {
  final NavigateLogic logic = Get.find<NavigateLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: logic.pageController,
        children: logic.pages,
      ),
      bottomNavigationBar: GetBuilder<NavigateLogic>(
        id: 'navigate',
        builder: (logic) {
          return NavigationBar(
            destinations: logic.labels,
            selectedIndex: logic.currentIndex,
            onDestinationSelected: logic.changePage,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<NavigateLogic>();
    super.dispose();
  }
}
