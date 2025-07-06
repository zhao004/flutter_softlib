# 软件库App

## Flutter环境

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

## 编译指令

```shell
# 混淆打包
flutter build apk --release --target-platform android-arm64 --obfuscate --split-debug-info=./build_info
# 正常打包
flutter build apk --target-platform android-arm64
```