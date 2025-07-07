# Flutter SoftLib

一个基于Flutter开发的软件库应用程序。

![app_example.jpg](assets/images/example/app_example.png)

## ⚠️ 重要声明

**本项目为开源学习项目。**

- 🎓 **学习用途**：本项目旨在展示Flutter开发技术和最佳实践
- 🚫 **禁止非法使用**：严禁将本项目用于任何非法活动或商业用途
- 📝 **免责声明**：开发者不对使用本项目造成的任何后果承担责任
- 🔒 **合规使用**：使用者需确保遵守当地法律法规

## 许可证

本项目基于 [MIT License](LICENSE) 开源协议。

**请合理使用，共同维护开源社区环境！**

# Flutter环境

```textmate
[√] Flutter (Channel stable, 3.32.5, on Microsoft Windows [版本 10.0.19045.5965], locale zh-CN)
[√] Windows Version (10 专业版 64 位, 22H2, 2009)
[√] Android toolchain - develop for Android devices (Android SDK version 36.0.0)
[√] Chrome - develop for the web
[√] Visual Studio - develop Windows apps (Visual Studio Community 2022 17.14.0)
[√] Android Studio (version 2024.3.2)
[√] IntelliJ IDEA Ultimate Edition (version 2025.1)
[√] Connected device (3 available)
[√] Network resources
```

## 视频教程

### [哔哩哔哩](https://search.bilibili.com/all?keyword=flutter%20%E6%89%93%E5%8C%85)

## 部分步骤

### 下载 **[Flutter SDK](https://docs.flutter.cn/install/archive)**

![Untitled.png](assets/images/example/install_flutter.png)

**下载安装后执行 `flutter --version` 验证是否安装成功**

![verify_flutter.png](assets/images/example/verify_flutter.png)

### 下载 **[Java SDK](https://www.oracle.com/java/technologies/javase/jdk11-archive-downloads.html)**

![install_java.png](assets/images/example/install_java.png)
**下载安装后执行 `java --version` 验证是否安装成功**
![verify_java.png](assets/images/example/verify_java.png)

### 修改软件名称

![modify_app_name.png](assets/images/example/modify_app_name.png)

### 修改软件图标

当前项目下终端执行：`dart run flutter_launcher_icons`

![modify_app_icon.png](assets/images/example/modify_app_icon.png)

### 修改软件包名

![modify_app_package_name.png](assets/images/example/modify_app_package_name.png)

### 配置软件签名

**自己去百度搜索Android 项目签名配置**

### 配置后台地址

当前项目下终端执行：`dart run build_runner build`

![config_backstage.png](assets/images/example/config_backstage.png)

## 编译指令 编译arm64架构的apk(这个架构支持大部分安卓手机,不支持模拟器)

```shell
# 混淆打包
flutter build apk --release --target-platform android-arm64 --obfuscate --split-debug-info=./build_info
# 正常打包
flutter build apk --target-platform android-arm64
```

# 问题反馈群,有什么问题可以在群里反馈,大家一起交流,一起提升技术

![qrcode_1751853555740.jpg](assets/images/example/qrcode_1751853555740.jpg)
