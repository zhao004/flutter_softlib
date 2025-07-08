import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

import '../../../../generated/assets.dart';
import '../../../models/http/results/carousel_model.dart';
import '../../../models/http/results/referral_model.dart';
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
            Text('首页', style: TextStyle(fontWeight: FontWeight.w500)),
            buildWord(),
          ],
        ),
        actionsPadding: const EdgeInsets.only(right: 5),
        actions: [
          IconButton(icon: Icon(Icons.group_add), onPressed: logic.joinGroup),
          IconButton(
            icon: Icon(Icons.support_agent),
            onPressed: logic.joinUser,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [buildCarousel(), buildPlacard(), buildReferral()],
        ),
      ),
    );
  }

  GetBuilder<HomeLogic> buildWord() {
    return GetBuilder<HomeLogic>(
      id: 'word',
      builder: (logic) {
        String? word = logic.word;
        if (word == null || word.isEmpty) {
          return SizedBox();
        }
        return Text(
          word,
          style: Get.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w300,
          ),
        );
      },
    );
  }

  /// 滚动公告
  Widget buildPlacard() {
    return GetBuilder<HomeLogic>(
      id: 'placard',
      builder: (logic) {
        String? placard = logic.configData?.placard;
        if (placard == null || placard.isEmpty) {
          return SizedBox.shrink();
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 5,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.campaign),
            ),
            Expanded(
              child: SizedBox(
                height: 20,
                child: Marquee(
                  text: placard,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  blankSpace: 100,
                  startPadding: 20,
                  accelerationDuration: Duration(seconds: 1),
                  accelerationCurve: Curves.linear,
                  decelerationDuration: Duration(seconds: 1),
                  decelerationCurve: Curves.linear,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 轮播图
  Widget buildCarousel() {
    return GetBuilder<HomeLogic>(
      id: 'carousel',
      builder: (logic) {
        List<CarouselData>? carouselsTemp = logic.carouses;
        if (carouselsTemp == null || carouselsTemp.isEmpty) {
          return SizedBox.shrink();
        }
        return CarouselSlider.builder(
          itemCount: carouselsTemp.length,
          itemBuilder: (context, index, realIdx) {
            final item = carouselsTemp[index];
            return GestureDetector(
              onTap: () => logic.onCarouselTap(item),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: item.image ?? '',
                      fit: BoxFit.cover,
                      placeholder: (context, url) {
                        return Center(
                          child: Image.asset(
                            Assets.imagesSucceed,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Center(
                          child: Image.asset(
                            Assets.imagesSucceed,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.black38, Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        child: Text(
                          item.title ?? '',
                          style: Get.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(1, 1),
                                blurRadius: 1,
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: Get.height / 5,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            autoPlayCurve: Curves.fastOutSlowIn,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
          ),
        );
      },
    );
  }

  /// 推荐
  Widget buildReferral() {
    return GetBuilder<HomeLogic>(
      id: 'referral',
      builder: (logic) {
        List<ReferralData>? referrals = logic.referrals;
        if (referrals == null || referrals.isEmpty) {
          return SizedBox.shrink();
        }
        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              title: Text('官方推荐'),
              titleTextStyle: TextStyle(
                fontSize: 20,
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Builder(
              builder: (context) {
                if (referrals.isEmpty) {
                  return Text(
                    '暂无推荐',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                  child: GridView.builder(
                    itemCount: referrals.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.8,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      String image = referrals[index].image ?? '';
                      String title = referrals[index].title ?? '';
                      return GestureDetector(
                        onTap: () => logic.onReferralTap(referrals[index]),
                        child: Card(
                          elevation: 0.1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: GridTile(
                              child: Stack(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: image,
                                    fit: BoxFit.cover,
                                    width: Get.height,
                                    placeholder: (context, url) {
                                      return Center(
                                        child: Image.asset(
                                          Assets.imagesSucceed,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    },
                                    errorWidget: (context, url, error) {
                                      return Image.asset(
                                        Assets.imagesSucceed,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: Get.textTheme.titleSmall?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
