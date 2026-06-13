# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

KDE Plasma 5 桌面小部件（plasmoid），用于实时显示系统监控信息：CPU 使用率/温度、GPU 温度、内存/交换分区、运行时间等。纯 QML + JavaScript 实现，无 C++ 代码。

**插件 ID:** `org.kde.simpleMonitor`
**当前版本:** 0.6.7
**目标框架:** KDE Plasma 5 / KF5（尽管仓库名含 "plasma6"）

## 常用命令

```bash
# 开发调试（推荐，直接预览小部件）
plasmoidviewer -f planar -a plasmoid/

# 用户级安装/更新（无 i18n）
plasmapkg2 -t plasmoid -i ./plasmoid    # 首次安装
plasmapkg2 -t plasmoid -u ./plasmoid    # 更新
plasmapkg2 -r ./plasmoid               # 卸载

# CMake 构建（系统级安装，含 i18n）
./build.sh                              # 等同于 mkdir build && cd build && cmake .. && make
cd build && sudo make install

# 清理 QML 编译缓存
./clearLaunch.sh                        # 删除 *.qmlc *.jsc

# 打包为 .plasmoid
cd plasmoid && zip -r plasma-simpleMonitor.plasmoid contents metadata.desktop
```

无测试套件、无 linter、无 CI/CD。

## 架构

### 数据流

1. **入口** — `plasmoid/metadata.desktop` 声明 `X-Plasma-MainScript=ui/main.qml`
2. **main.qml** 创建 `confEngine`（读取所有配置项）和多个 `PlasmaCore.DataSource`：
   - `systemInfoDataSource`（engine: `systemmonitor`）— CPU 负载、温度、内存、运行时间
   - GPU 温度通过 `executable` engine 调用 `nvidia-smi` / `aticonfig` / `amdconfig`
3. 数据存入 `ListModel`（`cpuModel`, `coreTempModel`, `gpuTempModel`）和直接属性
4. `Loader` 根据 `skin` 配置动态加载皮肤
5. 皮肤继承 `BaseSkin.qml`，组合 `monitorWidgets/` 下的组件

### 关键目录

- `plasmoid/contents/ui/` — QML 界面（main.qml 入口 + skins/ 皮肤 + monitorWidgets/ 组件 + config/ 配置页）
- `plasmoid/contents/code/code.js` — JS 辅助函数（发行版 logo 解析、读取 /etc/os-release）
- `plasmoid/contents/config/` — KDE kcfg 配置模式（main.xml）+ 配置分类（config.qml）
- `plasmoid/contents/fonts/` — 内置字体（Doppio One, Michroma, Monda, Play）
- `plasmoid/contents/images/` — SVG 图标和发行版 logo
- `translations/` — i18n 翻译文件（es_ES, eu_ES, pl, ru, tr）

### 配置体系

配置在 `main.xml`（kcfg XML）中定义，通过三个配置页暴露给用户：
- **General** — logo 选择、背景样式、温度阈值、开关（GPU/swap/uptime）
- **Skins** — 皮肤切换（Default/Column/Minimalistic），带预览
- **Misc** — CPU 指示条样式、刷新间隔

### QML API 版本

当前使用 Plasma 5 API：`org.kde.plasma.plasmoid 2.0`、`org.kde.plasma.core 2.0`、`org.kde.plasma.components 2.0`。迁移到 Plasma 6 需要更新这些 import 和对应的 API 调用。
