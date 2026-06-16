/**
 * Copyright 2013-2016 Dhaby Xiloj, Konstantin Shtepa
 **/
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root
    preferredRepresentation: fullRepresentation
    property bool showGpuTemp: plasmoid.configuration.showGpuTemp
    property var cpuLastSample: null

    property real memFree: 0; property real memTotal: 0; property real memUsed: 0
    property real memBuffers: 0; property real memCached: 0
    property real swapFree: 0; property real swapTotal: 0; property real swapUsed: 0
    property real uptime: 0

    // 同步到 confEngine 供皮肤访问
    onMemTotalChanged: confEngine.memTotal = memTotal
    onMemFreeChanged: confEngine.memFree = memFree
    onMemUsedChanged: confEngine.memUsed = memUsed
    onMemBuffersChanged: confEngine.memBuffers = memBuffers
    onMemCachedChanged: confEngine.memCached = memCached
    onSwapTotalChanged: confEngine.swapTotal = swapTotal
    onSwapFreeChanged: confEngine.swapFree = swapFree
    onSwapUsedChanged: confEngine.swapUsed = swapUsed
    onUptimeChanged: confEngine.uptime = uptime

    function parseExecOutput(text) {
        if (!text) return
        var lines = text.split('\n')
        var newSample = {}
        for (var i = 0; i < lines.length; i++) {
            var line = lines[i].trim()
            var eq = line.indexOf('=')
            if (eq < 0) continue
            var key = line.substring(0, eq)
            var val = line.substring(eq + 1)
            if (key === "UPTIME") { root.uptime = parseFloat(val); continue }
            if (key === "MemTotal")   { root.memTotal   = parseInt(val) * 1024; continue }
            if (key === "MemFree")    { root.memFree    = parseInt(val) * 1024; continue }
            if (key === "MemAvailable"){ root.memUsed  = root.memTotal - parseInt(val) * 1024; continue }
            if (key === "Buffers")    { root.memBuffers = parseInt(val) * 1024; continue }
            if (key === "Cached")     { root.memCached  = parseInt(val) * 1024; continue }
            if (key === "SwapFree")   { root.swapFree   = parseInt(val) * 1024; continue }
            if (key === "SwapTotal")  { root.swapTotal  = parseInt(val) * 1024; continue }
            if (key === "OS_NAME")    { confEngine.distroName = val; continue }
            if (key === "OS_ID")      { confEngine.distroId = val; continue }
            if (key === "OS_VERSION") { confEngine.distroVersion = val; continue }
            if (key === "KERNEL_NAME")    { confEngine.kernelName = val; continue }
            if (key === "KERNEL_VERSION") { confEngine.kernelVersion = val; continue }
            // CPU cores: store idle/total for delta calculation
            var m = key.match(/^cpu(\d+)_(idle|total)$/)
            if (m) {
                var num = parseInt(m[1]), field = m[2]
                if (!newSample[num]) newSample[num] = {}
                newSample[num][field] = parseInt(val)
            }
            // Thermal zones
            var tm = key.match(/^TZ(\d+)$/)
            if (tm) {
                var tz = parseInt(tm[1]), tv = parseInt(val) / 1000
                if (tv > 0 && tv < 200) {
                    if (coreTempModel.count <= tz) coreTempModel.append({'val': tv, 'dataUnits': '°C', 'coreLabelStr': ''})
                    else coreTempModel.set(tz, {'val': tv, 'dataUnits': '°C', 'coreLabelStr': ''})
                }
            }
            // HWMon (GPU)
            var hm = key.match(/^HW_(.+)_(\d+)$/)
            if (hm && hm[1].search(/gpu|amdgpu|radeon|nvidia/i) >= 0 && hm[2] === "1") {
                var hv = parseInt(val) / 1000
                if (hv > 0 && !isNaN(hv)) {
                    if (gpuTempModel.count === 0) gpuTempModel.append({'val': hv, 'dataUnits': '°C', 'gpuLabelStr': 'GPU'})
                    else gpuTempModel.set(0, {'val': hv, 'dataUnits': '°C', 'gpuLabelStr': 'GPU'})
                }
            }
        }
        // Compute CPU deltas
        if (root.cpuLastSample) {
            for (var n in newSample) {
                if (!newSample.hasOwnProperty(n)) continue
                var cur = newSample[n], prev = root.cpuLastSample[n]
                if (!cur.idle || !cur.total || !prev) continue
                var dT = cur.total - prev.total, dI = cur.idle - prev.idle
                if (dT > 0) {
                    var usage = Math.round((dT - dI) / dT * 100)
                    if (cpuModel.count <= n) cpuModel.append({'val': usage})
                    else cpuModel.set(n, {'val': usage})
                }
            }
        }
        root.cpuLastSample = newSample
        root.swapUsed = root.swapTotal - root.swapFree
    }

    Plasma5Support.DataSource {
        id: execDs
        engine: "executable"
        connectedSources: ["bash " + String(Qt.resolvedUrl("../code/data.sh")).replace("file://", "")]
        interval: confEngine.updateInterval * 1000
        onNewData: function(sourceName, data) {
            var out = data["stdout"] || ""
            parseExecOutput(String(out))
        }
    }

    QtObject {
        id: confEngine
        property int skin: plasmoid.configuration.skin
        property int bgColor: plasmoid.configuration.bgColor
        property int logo: plasmoid.configuration.logo
        property bool showGpuTemp: plasmoid.configuration.showGpuTemp
        property bool showSwap: plasmoid.configuration.showSwap
        property bool showUptime: plasmoid.configuration.showUptime
        property int tempUnit: plasmoid.configuration.tempUnit
        property int cpuHighTemp: plasmoid.configuration.cpuHighTemp
        property int cpuCritTemp: plasmoid.configuration.cpuCritTemp
        property bool coloredCpuLoad: plasmoid.configuration.coloredCpuLoad
        property bool flatCpuLoad: plasmoid.configuration.flatCpuLoad
        property int indicatorHeight: plasmoid.configuration.indicatorHeight
        property double updateInterval: plasmoid.configuration.updateInterval
        property string distroName: "tux"; property string distroId: "tux"
        property string distroVersion: ""; property string kernelName: ""; property string kernelVersion: ""
        property int direction: Qt.LeftToRight
        // 系统数据（供皮肤访问）
        property real memFree: 0; property real memTotal: 0; property real memUsed: 0
        property real memBuffers: 0; property real memCached: 0
        property real swapFree: 0; property real swapTotal: 0; property real swapUsed: 0
        property real uptime: 0
    }

    ListModel { id: cpuModel }
    ListModel { id: coreTempModel }
    ListModel { id: gpuTempModel }

    fullRepresentation: ColumnLayout {
        id: rep
        spacing: 0
        Layout.minimumWidth: loader.implicitWidth
        Layout.minimumHeight: loader.implicitHeight
        Layout.preferredWidth: loader.implicitWidth
        Layout.preferredHeight: loader.implicitHeight
        Rectangle {
            id: repBg
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "black"
            Loader {
                id: loader
                Layout.fillWidth: true
                Layout.preferredHeight: item ? item.implicitHeight : 0
                Layout.minimumHeight: item ? item.implicitHeight : 0
                source: "skins/DefaultSkin.qml"
            }
        }
        Connections {
            target: confEngine
            function onSkinChanged() {
                switch(confEngine.skin){ default:case 0:loader.source="skins/DefaultSkin.qml";break;case 1:loader.source="skins/ColumnSkin.qml";break;case 2:loader.source="skins/MinimalisticSkin.qml";break }
            }
            function onBgColorChanged() {
                switch(confEngine.bgColor){
                default:case 0:repBg.color="black";root.Plasmoid.backgroundHints=PlasmaCore.Types.StandardBackground;break
                case 1:repBg.color="transparent";root.Plasmoid.backgroundHints=PlasmaCore.Types.NoBackground;break
                case 2:repBg.color="transparent";root.Plasmoid.backgroundHints=PlasmaCore.Types.TranslucentBackground;break
                }
            }
        }
        Component.onCompleted: { confEngine.skinChanged(); confEngine.bgColorChanged() }
    }
}
