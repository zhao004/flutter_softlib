# Flutter SoftLib

<p align="left">
  <a href="https://github.com/zhao004/flutter_softlib">
    <img src="https://img.shields.io/badge/GitHub-flutter__softlib-181717?style=for-the-badge&logo=github&logoColor=white" alt="GitHub">
  </a>
  <a href="https://flutter.dev">
    <img src="https://img.shields.io/badge/Flutter-3.38.7-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  </a>
  <a href="https://dart.dev">
    <img src="https://img.shields.io/badge/Dart-%3E%3D3.10.0%20%3C4.0.0-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  </a>
</p>

[简体中文](README.zh-CN.md) | [English](README.en.md)

## 重要声明

本项目为开源学习项目。

- 学习用途：用于展示 Flutter 应用开发、下载管理和 Android 打包流程。
- 合规使用：请确保使用行为符合当地法律法规。
- 禁止非法使用：严禁将本项目用于任何违法场景。
- 免责声明：开发者不对使用本项目造成的任何后果承担责任。

## 项目简介

Flutter SoftLib 是一个面向 Android 的 Flutter 软件库应用示例，包含首页推荐、软件分类、资源搜索、线报阅读、下载管理和版本更新提示等能力。

- 首页：轮播图、公告、官方推荐。
- 应用：分类切换、软件详情、资源搜索、下载任务管理。
- 线报：分类列表、文章阅读、图片预览。
- 系统：启动权限申请、版本更新提示、数据库持久化下载记录。

## 技术栈

- Flutter + Material 3
- GetX
- Dio + Retrofit
- Drift
- Flutter Downloader
- FlexColorScheme / EasyLoading

## 后端项目

- 后端开源地址：[php_softlib_fastadminplugs](https://github.com/zhao004/php_softlib_fastadminplugs)

## 运行环境

已验证环境如下：

- Flutter `3.38.7`（stable）
- Dart SDK `>=3.10.0 <4.0.0`
- Java `11+`
- Android SDK `36.1.0`
- Android Studio `2024.3.2`
- Windows 11 或更高版本

## 项目预览

![应用示例](assets/images/example/app_example.png)

## 快速开始

### 1. 安装 Flutter SDK

- 下载地址：[Flutter SDK Archive](https://docs.flutter.cn/install/archive)

![安装 Flutter](assets/images/example/install_flutter.png)

- 安装完成后执行以下命令验证：

```shell
flutter --version
```

![验证 Flutter](assets/images/example/verify_flutter.png)

### 2. 安装 Java SDK

- 下载地址：[Java SDK](https://www.oracle.com/java/technologies/javase/jdk11-archive-downloads.html)

![安装 Java](assets/images/example/install_java.png)

- 安装完成后执行以下命令验证：

```shell
java --version
```

![验证 Java](assets/images/example/verify_java.png)

### 3. 安装依赖并运行

在项目根目录执行：

```shell
flutter pub get
flutter run
```

## 常见配置

### 修改软件名称

- 推荐使用 `build.bat` 统一配置。
- 手动方式可修改 `android/app/src/main/AndroidManifest.xml` 中的 `android:label`。

![修改软件名称](assets/images/example/modify_app_name.png)

### 修改软件图标

- 将图标资源放到 `assets/icon/icon.png`。
- 在项目根目录执行：

```shell
dart run flutter_launcher_icons
```

![修改软件图标](assets/images/example/modify_app_icon.png)

### 修改软件包名

- 推荐通过 `build.bat` 输入新的包名。
- 手动方式需要同步更新 `android/app/build.gradle.kts` 中的 `applicationId` 与 `namespace`。

![修改软件包名](assets/images/example/modify_app_package_name.png)

### 配置软件签名

- `build.bat` 支持交互式生成 `key.properties`。
- 如果手动配置，请按 Android 标准签名流程为 `android/` 工程补齐签名信息。

### 配置后台地址

- 修改 `lib/app/http/http_api.dart` 中 `@RestApi(baseUrl: '...')` 的地址。
- 修改后执行：

```shell
dart run build_runner build --delete-conflicting-outputs
```

![配置后台地址](assets/images/example/config_backstage.png)

## 编译方式

### 方式一：`build.bat`（推荐）

`build.bat` 为 Windows 环境提供一站式交互式构建流程，会依次完成：

- 检查 Flutter、Java 与 Android SDK 环境。
- 执行 `flutter pub get`。
- 配置软件名称、版本号、包名。
- 配置后台地址并执行 `build_runner`。
- 可选生成应用图标。
- 可选生成 `key.properties`。
- 输出 Debug / Release / Obfuscate Release APK。

运行方式：

```bat
build.bat
```

### 方式二：手动编译

按需完成配置后，在项目根目录执行：

```shell
# 本地快速验证
flutter build apk --debug

# 混淆打包（arm64）
flutter build apk --release --target-platform android-arm64 --obfuscate --split-debug-info=./build_info

# 正常打包（arm64）
flutter build apk --target-platform android-arm64
```

## 项目结构

```text
android/                    Android 工程与打包配置
assets/                     图片、图标与文档截图资源
lib/
  app/
    database/               Drift 数据库与下载任务表
    http/                   Retrofit API 定义与生成文件
    pages/                  首页、应用、搜索、详情、线报等页面
    widgets/                应用列表与线报列表组件
build.bat                   Windows 一键构建脚本
pubspec.yaml                Flutter 依赖与应用配置
```

## 视频教程

- [哔哩哔哩：Flutter 打包相关内容](https://search.bilibili.com/all?keyword=flutter%20%E6%89%93%E5%8C%85)

## 许可证

本项目基于 [MIT License](LICENSE) 开源。

请合理使用，共同维护开源社区环境。
