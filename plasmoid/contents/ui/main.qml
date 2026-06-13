/**
 * Copyright 2013-2016 Dhaby Xiloj, Konstantin Shtepa
 *
 * This file is part of plasma-simpleMonitor.
 *
 * plasma-simpleMonitor is free software: you can redistribute it
 * and/or modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation, either
 * version 3 of the License, or any later version.
 *
 * plasma-simpleMonitor is distributed in the hope that it will be
 * useful, but WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with plasma-simpleMonitor.  If not, see <http://www.gnu.org/licenses/>.
 **/

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.plasma.plasmoid
import org.kde.plasma.extras as PlasmaExtras
import org.kde.ksysguard.sensors as Sensors

import "../code/code.js" as Code

Rectangle {
    id: root

    width: implicitWidth
    height: implicitHeight

    implicitWidth: loader.implicitWidth
    implicitHeight: loader.implicitHeight

    Layout.minimumWidth: implicitWidth
    Layout.minimumHeight: implicitHeight
    Layout.preferredWidth: implicitWidth
    Layout.preferredHeight: implicitHeight

    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation

    color: "black"

    property bool atkPresent: false

    Component.onCompleted: atkPresent = false

    property bool showGpuTemp: plasmoid.configuration.showGpuTemp

    // 内存传感器绑定，供皮肤 delegate 读取
    property alias memFree: memFreeSensor.value
    property alias memTotal: memTotalSensor.value
    property alias memUsed: memUsedSensor.value
    property alias memBuffers: memBuffersSensor.value
    property alias memCached: memCachedSensor.value
    property alias swapFree: swapFreeSensor.value
    property alias swapTotal: swapTotalSensor.value
    property alias swapUsed: swapUsedSensor.value
    property alias uptime: uptimeSensor.value

    QtObject {
        id: confEngine

        property int skin:              plasmoid.configuration.skin
        property int bgColor:           plasmoid.configuration.bgColor
        property int logo:              plasmoid.configuration.logo
        property bool showGpuTemp:      plasmoid.configuration.showGpuTemp
        property bool showSwap:         plasmoid.configuration.showSwap
        property bool showUptime:       plasmoid.configuration.showUptime
        property int tempUnit:          plasmoid.configuration.tempUnit
        property int cpuHighTemp:       plasmoid.configuration.cpuHighTemp
        property int cpuCritTemp:       plasmoid.configuration.cpuCritTemp
        property bool coloredCpuLoad:   plasmoid.configuration.coloredCpuLoad
        property bool flatCpuLoad:      plasmoid.configuration.flatCpuLoad
        property int indicatorHeight:   plasmoid.configuration.indicatorHeight
        property double updateInterval: plasmoid.configuration.updateInterval

        property string distroName: "tux"
        property string distroId: "tux"
        property string distroVersion: ""
        property string kernelName: ""
        property string kernelVersion: ""

        property int direction: Qt.LeftToRight

        onSkinChanged: {
            switch (skin) {
            default:
            case 0:
                loader.source = "skins/DefaultSkin.qml";
                root.Layout.maximumWidth = root.Layout.preferredWidth;
                root.Layout.maximumHeight = root.Layout.preferredHeight;
                root.Layout.maximumWidth = Number.POSITIVE_INFINITY;
                root.Layout.maximumHeight = Number.POSITIVE_INFINITY;
                break;
            case 1:
                loader.source = "skins/ColumnSkin.qml"
                root.Layout.maximumWidth = root.Layout.preferredWidth;
                root.Layout.maximumHeight = root.Layout.preferredHeight;
                root.Layout.maximumWidth = Number.POSITIVE_INFINITY;
                root.Layout.maximumHeight = Number.POSITIVE_INFINITY;
                break;
            case 2:
                loader.source = "skins/MinimalisticSkin.qml"
                root.Layout.maximumWidth = root.Layout.preferredWidth;
                root.Layout.maximumHeight = root.Layout.preferredHeight;
                root.Layout.maximumWidth = Number.POSITIVE_INFINITY;
                root.Layout.maximumHeight = Number.POSITIVE_INFINITY;
                break;
            }
        }

        onBgColorChanged: {
            switch (bgColor) {
            default:
            case 0:
                root.color = "black";
                Plasmoid.backgroundHints = PlasmaTypes.StandardBackground;
                break;
            case 1:
                root.color = "transparent";
                Plasmoid.backgroundHints = PlasmaTypes.NoBackground;
                break;
            case 2:
                root.color = "transparent";
                Plasmoid.backgroundHints = PlasmaTypes.TranslucentBackground;
                break;
            }
        }

        Component.onCompleted: {
            Code.getDistroInfo(function(info) {
                distroName = info['name']
                distroId = info['id']
                distroVersion = info['version']
            }, this);

            Code.getKernelInfo(function(info){
                kernelName = info['name']
                kernelVersion = info['version']
            }, this);
        }
    }

    ListModel {
        id: cpuModel

        function getAll() {
            let list = [];
            for(let i=0; i < cpuModel.count; i++) {
                list.push(cpuModel.get(i));
            }
            return list;
        }
    }

    ListModel {
        id: coreTempModel

        function getAll() {
            let list = [];
            for(let i=0; i < coreTempModel.count; i++) {
                list.push(coreTempModel.get(i));
            }
            return list;
        }
    }

    ListModel {
        id: gpuTempModel
    }

    // === KSystemStats 传感器 ===

    // CPU 负载（每核）
    Repeater {
        id: cpuSensorsRepeater
        model: 128
        Sensors.Sensor {
            sensorId: "cpu/cpu" + index + "/usage"
            onValueChanged: {
                if (value >= 0) {
                    if (cpuModel.count <= index)
                        cpuModel.append({'val': value});
                    else
                        cpuModel.set(index, {'val': value});
                }
            }
        }
    }

    // CPU 温度（每核）
    Repeater {
        id: coreTempSensorsRepeater
        model: 128
        Sensors.Sensor {
            sensorId: "cpu/cpu" + index + "/temperature"
            onValueChanged: {
                if (value > 0) {
                    if (coreTempModel.count <= index)
                        coreTempModel.append({'val': value, 'dataUnits': '°C', 'coreLabelStr': ''});
                    else
                        coreTempModel.set(index, {'val': value, 'dataUnits': '°C', 'coreLabelStr': ''});
                }
            }
        }
    }

    // 内存传感器
    Sensors.Sensor { id: memFreeSensor;    sensorId: "memory/physical/free" }
    Sensors.Sensor { id: memTotalSensor;   sensorId: "memory/physical/total" }
    Sensors.Sensor { id: memUsedSensor;    sensorId: "memory/physical/used" }
    Sensors.Sensor { id: memBuffersSensor; sensorId: "memory/physical/buffers" }
    Sensors.Sensor { id: memCachedSensor;  sensorId: "memory/physical/cached" }
    Sensors.Sensor { id: swapFreeSensor;   sensorId: "memory/swap/free" }
    Sensors.Sensor { id: swapTotalSensor;  sensorId: "memory/swap/total" }
    Sensors.Sensor { id: swapUsedSensor;   sensorId: "memory/swap/used" }

    // 运行时间
    Sensors.Sensor { id: uptimeSensor; sensorId: "system/uptime" }

    // GPU 温度（KSystemStats 原生传感器）
    Sensors.Sensor {
        id: gpuTempSensor
        sensorId: "gpu/gpu0/temperature"
        enabled: showGpuTemp
        onValueChanged: {
            if (value > 0) {
                if (gpuTempModel.count === 0)
                    gpuTempModel.append({'val': value, 'dataUnits': '°C', 'gpuLabelStr': 'GPU'});
                else
                    gpuTempModel.set(0, {'val': value, 'dataUnits': '°C', 'gpuLabelStr': 'GPU'});
            }
        }
    }

    // GPU 温度回退：KSystemStats 无传感器时，通过 nvidia-smi 命令获取
    PlasmaExtras.CommandRunner {
        id: nvidiaCmd
        running: false
        sourceCommand: "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader"

        onExited: function(exitCode, exitStatus, stdout, stderr) {
            if (exitCode !== 0 || stdout.trim() === "")
                return;
            var temperature = parseFloat(stdout.trim());
            if (isNaN(temperature))
                return;
            if (gpuTempModel.count === 0)
                gpuTempModel.append({'val': temperature, 'dataUnits': '°C', 'gpuLabelStr': 'NVIDIA GPU'});
            else
                gpuTempModel.set(0, {'val': temperature, 'dataUnits': '°C', 'gpuLabelStr': 'NVIDIA GPU'});
        }
    }

    Timer {
        interval: plasmoid.configuration.updateInterval * 1000
        running: showGpuTemp
        repeat: true
        onTriggered: nvidiaCmd.exec()
    }

    Loader {
        id: loader
        anchors.fill: parent
        source: "skins/DefaultSkin.qml"
    }
}
