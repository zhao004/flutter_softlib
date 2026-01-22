@echo off
title Flutter SoftLib Build Tool

setlocal enabledelayedexpansion

REM Verify Flutter project
if not exist "pubspec.yaml" (
    echo [ERROR] This is not a Flutter project.
    echo         Run this script in the project root.
    pause
    exit /b 1
)

echo.
echo ========================================
echo   Flutter SoftLib Build Tool
echo ========================================
echo.

REM Step 1: Flutter check
echo [1/10] Check Flutter
call flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Flutter not found in PATH.
    pause
    exit /b 1
)
echo [OK] Flutter found
echo.

REM Step 2: Java check
echo [2/10] Check Java
java --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Java not found in PATH.
    pause
    exit /b 1
)
echo [OK] Java found
echo.

REM Android SDK check
if "%ANDROID_HOME%"=="" (
    if "%ANDROID_SDK_ROOT%"=="" (
        echo [ERROR] ANDROID_HOME / ANDROID_SDK_ROOT is not set.
        echo         Example (cmd): set ANDROID_HOME=C:\\Android\\Sdk
        pause
        exit /b 1
    ) else (
        set "ANDROID_HOME=%ANDROID_SDK_ROOT%"
    )
)
echo [OK] ANDROID_HOME=%ANDROID_HOME%
echo.

REM Fetch deps
echo [3/10] Flutter pub get
call flutter pub get
if %errorlevel% neq 0 (
    echo [ERROR] flutter pub get failed.
    pause
    exit /b 1
)
echo [OK] Dependencies ready
echo.

REM Read current config
call :read_current_config

echo ========================================
echo   Custom Configuration
echo ========================================
echo.

REM Step 3: App name
echo [4/10] App name
echo Current: %CURRENT_APP_NAME%
set /p new_app_name=New app name (Enter to keep):
if "!new_app_name!"=="" set "new_app_name=%CURRENT_APP_NAME%"
echo Selected: !new_app_name!
echo.

REM Step 4: Version
echo [5/10] App version
echo Current: %CURRENT_VERSION%
set /p new_version=New version (format 1.0.0+1, Enter to keep):
if "!new_version!"=="" set "new_version=%CURRENT_VERSION%"
echo Selected: !new_version!
echo.

REM Step 5: Package name
echo [6/10] Package name
echo Current: %CURRENT_PACKAGE%
set /p new_package=New package (Enter to keep):
if "!new_package!"=="" set "new_package=%CURRENT_PACKAGE%"
echo Selected: !new_package!
echo.

REM Step 6: Backend URL
echo [7/10] Backend URL
set /p backend_url=Backend URL (Enter to skip):
if not "!backend_url!"=="" (
    echo Selected: !backend_url!
    call :configure_backend
    echo Running build_runner...
    call dart run build_runner build --delete-conflicting-outputs
    if !errorlevel! neq 0 (
        echo [WARN] build_runner finished with warnings.
    )
    echo [OK] Backend updated
) else (
    echo [SKIP] Backend update
)
echo.

REM Step 7: App icon
echo [8/10] App icon
findstr /C:"flutter_launcher_icons" pubspec.yaml >nul 2>&1
if !errorlevel! neq 0 (
    echo [WARN] flutter_launcher_icons not found in pubspec.yaml
    echo        Please configure it before generating icons.
) else (
    set /p change_icon=Generate app icons now? (y/N):
    if /i "!change_icon!"=="y" (
        call dart run flutter_launcher_icons
        if !errorlevel! neq 0 (
            echo [WARN] Icon generation finished with warnings.
        )
        echo [OK] Icons generated
    ) else (
        echo [SKIP] Icon generation
    )
)
echo.

REM Step 8: Signing
echo [9/10] Signing
echo 1. Debug signing
echo 2. Release signing
set /p signing_choice=Choose signing (1-2):
if "!signing_choice!"=="2" (
    call :configure_signing
    if !errorlevel! neq 0 (
        echo [WARN] Signing failed, fallback to Debug signing.
        set signing_choice=1
    )
) else (
    set signing_choice=1
)
echo.

REM Step 9: Build type
echo [10/10] Build type
echo 1. Release (obfuscate)
echo 2. Release (normal)
echo 3. Debug
set /p build_type=Choose build type (1-3) [1]:
if "!build_type!"=="" set build_type=1
if "!signing_choice!"=="1" if "!build_type!"=="1" (
    echo [WARN] Obfuscate Release with Debug signing is not recommended.
    echo.
)
echo.

REM Apply config
echo Applying configuration...
call :apply_configuration
if %errorlevel% neq 0 (
    echo [ERROR] Apply configuration failed.
    pause
    exit /b 1
)
echo [OK] Configuration applied
echo.

REM Build
if "!build_type!"=="1" goto obfuscate_build
if "!build_type!"=="2" goto release_build
if "!build_type!"=="3" goto debug_build

:debug_build
echo Building Debug APK...
call flutter build apk --debug
if %errorlevel% neq 0 (
    echo [ERROR] Debug build failed.
    pause
    exit /b 1
)
set "output_apk=build\app\outputs\flutter-apk\app-debug.apk"
set "build_desc=Debug"
goto show_result

:obfuscate_build
echo Building Release (obfuscate) APK...
call flutter build apk --release --target-platform android-arm64 --obfuscate --split-debug-info=./build_info
if %errorlevel% neq 0 (
    echo [ERROR] Obfuscate release build failed.
    pause
    exit /b 1
)
set "output_apk=build\app\outputs\flutter-apk\app-release.apk"
set "build_desc=Release (obfuscate)"
goto show_result

:release_build
echo Building Release APK...
call flutter build apk --target-platform android-arm64
if %errorlevel% neq 0 (
    echo [ERROR] Release build failed.
    pause
    exit /b 1
)
set "output_apk=build\app\outputs\flutter-apk\app-release.apk"
set "build_desc=Release"

:show_result
echo.
echo ========================================
echo Build completed
echo ========================================
echo App name: !new_app_name!
echo Version:  !new_version!
echo Package:  !new_package!
echo Type:     !build_desc!
echo Flutter:  OK
echo Java:     OK
echo.
echo Output: %cd%\%output_apk%
if exist "%output_apk%" (
    dir "%output_apk%" | findstr /i ".apk"
    echo.
    pause
    for %%f in ("%output_apk%") do explorer "%%~dpf"
) else (
    echo [ERROR] APK not found.
    pause
)
goto :eof

REM ==================== Functions ====================

:read_current_config
for /f "tokens=2 delims=:" %%i in ('findstr /b /c:"version:" pubspec.yaml 2^>nul') do (
    set "CURRENT_VERSION=%%i"
    set "CURRENT_VERSION=!CURRENT_VERSION: =!"
)
if "%CURRENT_VERSION%"=="" set "CURRENT_VERSION=1.0.0+1"

findstr "android:label=" android\app\src\main\AndroidManifest.xml >nul 2>&1
if !errorlevel! equ 0 (
    for /f "tokens=2 delims==&quot;" %%i in ('findstr "android:label=" android\app\src\main\AndroidManifest.xml 2^>nul') do (
        set "CURRENT_APP_NAME=%%i"
    )
)
if "%CURRENT_APP_NAME%"=="" set "CURRENT_APP_NAME=SoftLib"

findstr "applicationId" android\app\build.gradle.kts >nul 2>&1
if !errorlevel! equ 0 (
    for /f "tokens=2 delims=&quot;" %%i in ('findstr "applicationId" android\app\build.gradle.kts 2^>nul') do (
        set "CURRENT_PACKAGE=%%i"
    )
)
if "%CURRENT_PACKAGE%"=="" set "CURRENT_PACKAGE=com.softlib.flutter_softlib"
exit /b 0

:configure_backend
echo Updating http_api.dart baseUrl...
if not exist "lib\app\http\http_api.dart" (
    echo [ERROR] lib\app\http\http_api.dart not found.
    exit /b 1
)
powershell -NoProfile -Command "(gc lib\app\http\http_api.dart) -replace '@RestApi\(baseUrl: ''[^'']*''\)', '@RestApi(baseUrl: ''%backend_url%'')' | sc lib\app\http\http_api.dart"
if %errorlevel% neq 0 (
    echo [ERROR] Failed to update backend URL.
    exit /b 1
)
exit /b 0

:configure_signing
echo Signing setup
set /p keystore_path=Keystore path:
if "!keystore_path!"=="" (
    echo [ERROR] Keystore path is required.
    exit /b 1
)
if not exist "!keystore_path!" (
    echo [ERROR] Keystore file not found: !keystore_path!
    exit /b 1
)
set /p keystore_alias=Key alias [upload]:
if "!keystore_alias!"=="" set "keystore_alias=upload"
set /p keystore_password=Keystore password:
if "!keystore_password!"=="" (
    echo [ERROR] Keystore password is required.
    exit /b 1
)
set /p key_password=Key password [same as keystore]:
if "!key_password!"=="" set "key_password=%keystore_password%"

echo storePassword=%keystore_password%>key.properties
echo keyPassword=%key_password%>>key.properties
echo keyAlias=%keystore_alias%>>key.properties
echo storeFile=%keystore_path%>>key.properties
echo [OK] key.properties created
exit /b 0

:apply_configuration
if not exist "backup" mkdir backup
copy pubspec.yaml backup\pubspec.yaml.bak >nul 2>&1
copy android\app\src\main\AndroidManifest.xml backup\AndroidManifest.xml.bak >nul 2>&1
copy android\app\build.gradle.kts backup\build.gradle.kts.bak >nul 2>&1

powershell -NoProfile -Command "(gc pubspec.yaml) -replace 'version: .*', 'version: %new_version%' | sc pubspec.yaml"
if %errorlevel% neq 0 exit /b 1

powershell -NoProfile -Command "(gc android\app\src\main\AndroidManifest.xml) -replace 'android:label=&quot;.*&quot;', 'android:label=&quot;%new_app_name%&quot;' | sc android\app\src\main\AndroidManifest.xml"
if %errorlevel% neq 0 exit /b 1

if not "%new_package%"=="%CURRENT_PACKAGE%" (
    powershell -NoProfile -Command "(gc android\app\build.gradle.kts) -replace 'applicationId = &quot;.*&quot;', 'applicationId = &quot;%new_package%&quot;' | sc android\app\build.gradle.kts"
    powershell -NoProfile -Command "(gc android\app\build.gradle.kts) -replace 'namespace = &quot;.*&quot;', 'namespace = &quot;%new_package%&quot;' | sc android\app\build.gradle.kts"
    call flutter pub get >nul 2>&1
)
exit /b 0
