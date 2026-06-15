Plasma 简易系统监视器
======================

**[English](README.md)**

一个简洁的 Plasma 桌面系统监视器，完全使用 QML 和 JavaScript 编写。

依赖
====

- Plasma 6 (Plasma Shell)
- KDE Frameworks 6
- ksystemstats（系统监控传感器）

### CMake 额外依赖 ###

仅在使用 `cmake` 安装时需要。

- CMake >= 3.16
- Extra CMake Modules（`extra-cmake-modules`）
- Plasma Framework 开发包（`plasma-framework-devel` 或 `kf6-plasma-devel`）

安装
====

### CMake ###

如需本地化（i18n/l10n）支持，请使用 `cmake` 安装到系统目录，需要 root 权限。

````Shell
git clone https://github.com/wenyinos/plasma6-simpleMonitor.git
cd plasma6-simpleMonitor
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$(kf6-config --prefix) -DCMAKE_BUILD_TYPE=Release -DKDE_INSTALL_USE_QT_SYS_PATHS=ON ../
sudo make install
````

### KDE 包管理 ###

此方式更便捷，但不支持本地化。小部件将安装到用户主目录。

安装：
````Shell
git clone https://github.com/wenyinos/plasma6-simpleMonitor.git
cd plasma6-simpleMonitor
kpackagetool6 -t Plasma/Applet -i ./plasmoid
````

更新时使用 `kpackagetool6 -t Plasma/Applet -u ./plasmoid`。

卸载：
````Shell
kpackagetool6 -t Plasma/Applet -r org.kde.simpleMonitor
````

打包
====

生成 .plasmoid 安装包：

````Shell
git clone https://github.com/wenyinos/plasma6-simpleMonitor.git
cd plasma6-simpleMonitor/plasmoid
zip -r plasma-simpleMonitor.plasmoid contents metadata.json
````

开发
====

使用 `launch.sh` 脚本启动预览调试，无需安装。
使用 `clearLaunch.sh` 脚本清理 QML 编译缓存（`*.qmlc *.jsc`）。

翻译
====

支持语言：俄语（ru）、波兰语（pl）、土耳其语（tr）、简体中文（zh_CN）。

更新 .po 源文件后重建翻译：
````Shell
cd translations
./Messages.sh
````

许可证
======

本项目基于 GNU通用公共许可证 第3版或更高版本授权。

你可以在该许可证条款下修改和/或分发本软件。
