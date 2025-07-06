import 'package:flutter_softlib/app/utils/toast_util.dart';
import 'package:url_launcher/url_launcher_string.dart';

class JumpUtil {
  /// 浏览器打开网址
  static void openUrl(String url) {
    if (url.isEmpty) {
      ToastUtil.error('网址不能为空');
      return;
    }
    if (Uri.tryParse(url)?.hasScheme == true) {
      launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      ToastUtil.error('无效的网址: $url');
    }
  }

  /// 添加QQ群
  static Future<void> joinQQGroup(String groupCode) async {
    String qunUrl =
        "mqqapi://card/show_pslcard?src_type=internal&version=1&uin=$groupCode&card_type=group&source=qrcode";
    if (await canLaunchUrlString(qunUrl)) {
      await launchUrlString(
        qunUrl,
        mode: LaunchMode.externalNonBrowserApplication,
      );
    } else {
      ToastUtil.error('无法打开QQ群: $groupCode');
    }
  }

  /// 添加QQ好友
  static Future<void> addQQFriend(String qqNumber) async {
    String qqUrl =
        "mqqapi://card/show_pslcard?src_type=internal&source=sharecard&version=1&uin=$qqNumber";
    if (await canLaunchUrlString(qqUrl)) {
      await launchUrlString(
        qqUrl,
        mode: LaunchMode.externalNonBrowserApplication,
      );
    } else {
      ToastUtil.error('无法打开QQ: $qqNumber');
    }
  }
}
