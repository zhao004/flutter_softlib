import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_logic.dart';

class HomeComponent extends StatefulWidget {
  const HomeComponent({super.key});

  @override
  State<HomeComponent> createState() => _HomeComponentState();
}

class _HomeComponentState extends State<HomeComponent> {
  final HomeLogic logic = Get.find<HomeLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('首页'),
            Text(
              '我没有考试失败。我只是找到了100种做错的方法',
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.only(right: 5),
        actions: [
          //群聊
          IconButton(icon: Icon(Icons.group_add), onPressed: () {}),
          //客服
          IconButton(icon: Icon(Icons.support_agent), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            Placeholder(fallbackHeight: 200, child: Center(child: Text('轮播图'))),
            Placeholder(fallbackHeight: 50, child: Center(child: Text('公告'))),
            ListTile(
              title: Text('官方推荐'),
              titleTextStyle: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
              child: GridView.builder(
                itemCount: 10,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.8,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 0.1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GridTile(
                        header: Image.network(
                          'https://cdn.pixabay.com/photo/2013/12/14/07/29/lid-228366_1280.jpg',
                          fit: BoxFit.cover,
                        ),
                        footer: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            '超值流量卡超值流量卡超值流量卡超值流量卡超值流量卡 $index',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  offset: Offset(1, 1),
                                  blurRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                        child: Placeholder(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
