# AGENTS.md

## 项目定位

KDE Plasma 6 桌面小部件（plasmoid），实时显示 CPU/温度/GPU/内存/交换分区/运行时间。纯 QML + JavaScript + shell，无 C++。

- **插件 ID:** `org.kde.simpleMonitor`
- **版本:** 0.7（`plasmoid/metadata.json`）

> ⚠️ CLAUDE.md 中有多处过期信息（仍写 Plasma 5 / 版本 0.6.7 / metadata.desktop / systemmonitor engine / plasmapkg2），以本文件为准。

## 开发命令

```bash
# 预览调试（推荐）
./launch.sh                    # plasmoidviewer6 -f planar -a plasmoid/

# 用户级安装/更新
kpackagetool6 -t Plasma/Applet -i ./plasmoid   # 首次
kpackagetool6 -t Plasma/Applet -u ./plasmoid   # 更新
kpackagetool6 -t Plasma/Applet -r org.kde.simpleMonitor  # 卸载

# 快速安装+重启脚本（卸载旧版→安装→重建缓存→启动预览）
./build.sh

# CMake 系统级安装（含 i18n）
mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX=$(kf6-config --prefix) -DCMAKE_BUILD_TYPE=Release -DKDE_INSTALL_USE_QT_SYS_PATHS=ON ../ && sudo make install

# 清理 QML 编译缓存（改 QML 后预览未更新时运行）
./clearLaunch.sh

# 打包 .plasmoid
cd plasmoid && zip -r plasma-simpleMonitor.plasmoid contents metadata.json

# 重建翻译
cd translations && ./Messages.sh
```

无测试、无 linter、无 CI。

## 架构

### 数据流

1. `plasmoid/metadata.json` → `X-Plasma-MainScript` 指向 `ui/main.qml`
2. `main.qml` 通过 `Plasma5Support.DataSource`（engine: `executable`）周期性执行 `data.sh`
3. `data.sh` 读取 `/proc/meminfo`、`/proc/stat`、`/proc/uptime`、`/sys/class/thermal/`、`/sys/class/hwmon/`、`/etc/os-release`，输出 `key=value` 文本
4. `main.qml.parseExecOutput()` 解析文本，计算 CPU delta，更新 `ListModel` 和属性
5. `confEngine`（QtObject）桥接配置与数据，供皮肤访问
6. `Loader` 按 `skin` 配置动态加载 `skins/` 下的皮肤

**不再使用 `systemmonitor` engine，不调用 nvidia-smi / aticonfig。** 所有系统数据来自 `data.sh`。

### 关键文件

| 路径 | 作用 |
|------|------|
| `plasmoid/metadata.json` | 插件元数据（不是 metadata.desktop） |
| `plasmoid/contents/ui/main.qml` | 主入口：数据源、解析、Model、Loader |
| `plasmoid/contents/code/data.sh` | 系统数据采集脚本（key=value 输出） |
| `plasmoid/contents/code/code.js` | JS 辅助（发行版 logo 解析、os-release 读取） |
| `plasmoid/contents/config/main.xml` | kcfg 配置定义 |
| `plasmoid/contents/config/config.qml` | 配置页分类 |
| `plasmoid/contents/ui/skins/BaseSkin.qml` | 皮肤基类，从 confEngine 暴露属性给子组件 |
| `plasmoid/contents/ui/monitorWidgets/` | 可组合监控组件 |

### 皮肤

3 个皮肤（Default / Column / Minimalistic），但 `main.xml` 的 `skin` 枚举只定义了 Standard(0) 和 Column(1)。代码中 switch case 2 硬编码加载 MinimalisticSkin。新增皮肤需同时改枚举和 switch。

### 配置

3 个配置页：General / Skins / Miscellaneous，定义在 `main.xml`，UI 在 `ui/config/Config*.qml`。

## Plasma 6 API 注意

当前代码已用 Plasma 6 API：
- `import org.kde.plasma.plasmoid`（无版本号）
- `import org.kde.plasma.core as PlasmaCore`
- `import org.kde.plasma.plasma5support as Plasma5Support`
- `PlasmoidItem` 替代旧 `PlasmaCore.IconItem`
- 工具链：`plasmoidviewer6`、`kpackagetool6`、`kf6-config`

## 常见陷阱

- **改了 QML 预览不生效** → 运行 `./clearLaunch.sh` 删 `*.qmlc *.jsc` 缓存
- **`data.sh` 必须可执行** — `install.sh` 会 `chmod +x`，但手动部署可能遗漏
- **`main.xml` 枚举与代码不同步** — 皮肤枚举缺少 Minimalistic 选项，靠 switch 硬编码补位
- **打包用 `metadata.json` 不是 `metadata.desktop`** — README 中旧命令已更新，CLAUDE.md 未更新
- **翻译需预编译 `.mo`** — `install.sh` 会安装，`kpackagetool6` 安装不带翻译
