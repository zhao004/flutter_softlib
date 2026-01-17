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
  int _currentCarouselIndex = 0;

  /// 构建首页整体布局
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('首页', style: TextStyle(fontWeight: FontWeight.w500)),
            buildWord(),
          ],
        ),
        actionsPadding: const EdgeInsets.only(right: 5),
        actions: [
          IconButton(
            icon: const Icon(Icons.group_add),
            onPressed: logic.joinGroup,
          ),
          IconButton(
            icon: const Icon(Icons.support_agent),
            onPressed: logic.joinUser,
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          SliverToBoxAdapter(child: buildCarousel()),
          SliverToBoxAdapter(child: buildPlacard()),
          const SliverToBoxAdapter(child: SizedBox(height: 6)),
          buildReferralTitleSliver(),
          buildReferralGridSliver(),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }

  /// 构建标题下方的文案区域
  GetBuilder<HomeLogic> buildWord() {
    return GetBuilder<HomeLogic>(
      id: 'word',
      builder: (logic) {
        String? word = logic.word;
        if (word == null || word.isEmpty) {
          return const SizedBox.shrink();
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
          return const SizedBox.shrink();
        }
        final theme = Theme.of(context);
        final background = theme.colorScheme.surfaceVariant.withAlpha(60);
        final iconColor = theme.colorScheme.primary;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 8,
              children: [
                Icon(Icons.campaign, color: iconColor),
                Expanded(
                  child: SizedBox(
                    height: 20,
                    child: Marquee(
                      text: placard,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      scrollAxis: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      blankSpace: 100,
                      startPadding: 20,
                      accelerationDuration: const Duration(seconds: 1),
                      accelerationCurve: Curves.linear,
                      decelerationDuration: const Duration(seconds: 1),
                      decelerationCurve: Curves.linear,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 构建轮播图区域
  Widget buildCarousel() {
    return GetBuilder<HomeLogic>(
      id: 'carousel',
      builder: (logic) {
        List<CarouselData>? carouselsTemp = logic.carouses;
        if (carouselsTemp == null || carouselsTemp.isEmpty) {
          return const SizedBox.shrink();
        }
        final activeIndex = _currentCarouselIndex.clamp(
          0,
          carouselsTemp.length - 1,
        );
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CarouselSlider.builder(
                itemCount: carouselsTemp.length,
                itemBuilder: (context, index, realIdx) {
                  final item = carouselsTemp[index];
                  return GestureDetector(
                    onTap: () => logic.onCarouselTap(item),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
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
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.black45, Colors.transparent],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              child: Text(
                                item.title ?? '',
                                style: Get.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  shadows: const [
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
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  onPageChanged: (index, reason) {
                    if (_currentCarouselIndex != index) {
                      setState(() => _currentCarouselIndex = index);
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              _buildCarouselIndicator(carouselsTemp.length, activeIndex),
            ],
          ),
        );
      },
    );
  }

  /// 构建轮播图指示器
  Widget _buildCarouselIndicator(int length, int activeIndex) {
    if (length <= 1) {
      return const SizedBox.shrink();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: index == activeIndex ? 18 : 6,
          decoration: BoxDecoration(
            color: index == activeIndex
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).dividerColor,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  /// 构建推荐标题区域
  Widget buildReferralTitleSliver() {
    return GetBuilder<HomeLogic>(
      id: 'referral',
      builder: (logic) {
        List<ReferralData>? referrals = logic.referrals;
        if (referrals == null || referrals.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Text(
              '官方推荐',
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  /// 构建推荐内容网格
  Widget buildReferralGridSliver() {
    return GetBuilder<HomeLogic>(
      id: 'referral',
      builder: (logic) {
        List<ReferralData>? referrals = logic.referrals;
        if (referrals == null || referrals.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.7,
            ),
            delegate: SliverChildBuilderDelegate((
              BuildContext context,
              int index,
            ) {
              return _buildReferralCard(referrals[index]);
            }, childCount: referrals.length),
          ),
        );
      },
    );
  }

  /// 构建推荐卡片
  Widget _buildReferralCard(ReferralData data) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => logic.onReferralTap(data),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: data.image ?? '',
              fit: BoxFit.cover,
              placeholder: (context, url) {
                return Center(
                  child: Image.asset(Assets.imagesSucceed, fit: BoxFit.cover),
                );
              },
              errorWidget: (context, url, error) {
                return Image.asset(Assets.imagesSucceed, fit: BoxFit.cover);
              },
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black54],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  data.title ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    shadows: const [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(1, 1),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
