import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_softlib/app/http/http_api.dart';
import 'package:flutter_softlib/app/utils/jump_util.dart';
import 'package:flutter_softlib/app/utils/toast_util.dart';
import 'package:get/get.dart';

import '../../../../generated/assets.dart';
import '../../../config.dart';
import '../../../models/http/results/carousel_model.dart';
import '../../../models/http/results/config_model.dart';
import '../../../models/http/results/referral_model.dart';
import '../../../routes/app_pages.dart';

class HomeLogic extends GetxController {
  HttpApi httpApi = Get.find<HttpApi>();
  List<CarouselData>? carouses;
  List<ReferralData>? referrals;
  ConfigData? configData;
  String? word;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getConfig();
    getWord();
    getCarouselSlider();
    getReferral();
  }

  ///获取配置
  Future<void> getConfig() async {
    try {
      var config = await httpApi.getConfig();
      if (config.code == 1) {
        configData = config.data;
      }
      update(['placard']);
    } catch (e) {
      logger.e(e.toString());
    }
  }

  ///获取轮播图
  Future<void> getCarouselSlider() async {
    try {
      CarouselModel carouselModel = await httpApi.getCarousel();
      if (carouselModel.code == 1) {
        carouses = carouselModel.data ?? [];
      }
      update(['carousel']);
    } catch (e) {
      logger.e(e.toString());
    }
  }

  ///获取推荐
  Future<void> getReferral() async {
    try {
      var referral = await httpApi.getReferral();
      if (referral.code == 1) {
        referrals = referral.data;
      }
      update(['referral']);
    } catch (e) {
      logger.e(e.toString());
    }
  }

  ///获取每日一句
  Future<void> getWord() async {
    try {
      var referral = await httpApi.getWord();
      if (referral.code == 1) {
        word = referral.data;
      }
      update(['word']);
    } catch (e) {
      logger.e(e.toString());
    }
  }

  ///跳转加群
  void joinGroup() {
    String? groupUrl = configData?.feedbackGroup;
    if (groupUrl != null && groupUrl.isNotEmpty) {
      showImage(groupUrl);
    } else {
      ToastUtil.error('暂未配置');
    }
  }

  ///跳转加客服
  void joinUser() {
    String? userUrl = configData?.feedbackUser;
    if (userUrl != null && userUrl.isNotEmpty) {
      showImage(userUrl);
    } else {
      ToastUtil.error('暂未配置');
    }
  }

  ///弹窗显示图片
  void showImage(String? imageUrl) {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(3),
          content: SizedBox(
            width: Get.width * 0.5,
            height: Get.height * 0.3,
            child: Stack(
              children: [
                Center(
                  child: SizedBox(
                    width: Get.width * 0.5,
                    height: Get.height * 0.3,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl ?? '',
                      fit: BoxFit.contain,
                      placeholder: (context, url) {
                        return Center(child: Image.asset(Assets.imagesSucceed));
                      },
                      errorWidget: (context, url, error) {
                        return Center(
                          child: Text(
                            '加载失败',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        );
                      },
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

  ///轮播图点击
  void onCarouselTap(CarouselData data) {
    if (data.type != 'url') return;
    if (data.url != null && data.url!.isNotEmpty) {
      JumpUtil.openUrl(data.url!);
    } else {
      ToastUtil.error('无效的链接');
    }
  }

  ///推荐点击
  void onReferralTap(ReferralData data) {
    if (data.type == 'url') {
      if (data.url != null && data.url!.isNotEmpty) {
        JumpUtil.openUrl(data.url!);
      } else {
        ToastUtil.error('无效的链接');
      }
    }
    if (data.type == 'page') {
      Get.toNamed(
        Routes.articleReading,
        arguments: {'title': data.title, 'content': data.content},
      );
    }
  }
}
