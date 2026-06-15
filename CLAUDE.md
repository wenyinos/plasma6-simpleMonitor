# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

KDE Plasma 6 桌面小部件（plasmoid），用于实时显示系统监控信息：CPU 使用率/温度、GPU 温度、内存/交换分区、运行时间等。纯 QML + JavaScript + shell 实现，无 C++ 代码。

**插件 ID:** `org.kde.simpleMonitor`
**当前版本:** 0.7（`plasmoid/metadata.json`）
**目标框架:** KDE Plasma 6 / KF6

## 常用命令

```bash
# 开发调试（推荐，直接预览小部件）
./launch.sh                              # plasmoidviewer6 -f planar -a plasmoid/

# 用户级安装/更新（无 i18n）
kpackagetool6 -t Plasma/Applet -i ./plasmoid   # 首次安装
kpackagetool6 -t Plasma/Applet -u ./plasmoid   # 更新
kpackagetool6 -t Plasma/Applet -r org.kde.simpleMonitor  # 卸载

# 快速安装+预览（卸载旧版→安装→重建缓存→启动预览）
./build.sh

# CMake 系统级安装（含 i18n）
mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX=$(kf6-config --prefix) -DCMAKE_BUILD_TYPE=Release -DKDE_INSTALL_USE_QT_SYS_PATHS=ON ../ && sudo make install

# 清理 QML 编译缓存（改 QML 后预览未更新时运行）
./clearLaunch.sh                        # 删除 *.qmlc *.jsc

# 打包为 .plasmoid
cd plasmoid && zip -r plasma-simpleMonitor.plasmoid contents metadata.json
```

无测试套件、无 linter、无 CI/CD。

## 架构

### 数据流

1. **入口** — `plasmoid/metadata.json` 定义插件元数据
2. **main.qml** 通过 `Plasma5Support.DataSource`（engine: `executable`）周期性执行 `data.sh`，`data.sh` 读取 `/proc/meminfo`、`/proc/stat`、`/proc/uptime`、`/sys/class/thermal/`、`/sys/class/hwmon/`、`/etc/os-release`，输出 `key=value` 文本
3. `main.qml.parseExecOutput()` 解析输出，计算 CPU delta，更新 `ListModel`（`cpuModel`, `coreTempModel`, `gpuTempModel`）和直接属性
4. GPU 温度来自 `/sys/class/hwmon/` sysfs（不再调用 nvidia-smi / aticonfig）
5. `confEngine`（QtObject）桥接配置与数据，供皮肤访问
6. `Loader` 根据 `skin` 配置动态加载 `skins/` 下的皮肤
7. 皮肤继承 `BaseSkin.qml`，组合 `monitorWidgets/` 下的组件

### 关键目录

- `plasmoid/contents/ui/` — QML 界面（main.qml 入口 + skins/ 皮肤 + monitorWidgets/ 组件 + config/ 配置页）
- `plasmoid/contents/code/data.sh` — 系统数据采集脚本（key=value 输出，所有数据来源）
- `plasmoid/contents/code/code.js` — JS 辅助函数（发行版 logo 解析、读取 /etc/os-release）
- `plasmoid/contents/config/` — KDE kcfg 配置模式（main.xml）+ 配置分类（config.qml）
- `plasmoid/contents/images/` — SVG 图标和发行版 logo
- `translations/` — i18n 翻译文件（ru, pl, tr, zh_CN）

### 配置体系

配置在 `main.xml`（kcfg XML）中定义，通过三个配置页暴露给用户：
- **General** — logo 选择、背景样式、温度阈值、开关（GPU/swap/uptime）
- **Skins** — 皮肤切换（Default/Column/Minimalistic），带预览
- **Misc** — CPU 指示条样式、刷新间隔

### QML API 版本

当前已使用 Plasma 6 API：
- `import org.kde.plasma.plasmoid`（无版本号）
- `import org.kde.plasma.core as PlasmaCore`
- `import org.kde.plasma.plasma5support as Plasma5Support`
- `PlasmoidItem` 替代旧 `PlasmaCore.IconItem`
- 工具链：`plasmoidviewer6`、`kpackagetool6`、`kf6-config`
