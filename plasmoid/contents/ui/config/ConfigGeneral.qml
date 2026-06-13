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
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

import "../../code/code.js" as Code

KCM.SimpleKCM {
    id: root

    property int cfg_bgColor
    property alias cfg_logo: logoComboBox.currentIndex
    property alias cfg_showGpuTemp: showGpuTempCheckBox.checked
    property alias cfg_showSwap: showSwapCheckBox.checked
    property alias cfg_showUptime: showUptimeCheckBox.checked
    property int cfg_tempUnit
    property alias cfg_cpuHighTemp: cpuHighTempSpinBox.value
    property alias cfg_cpuCritTemp: cpuCritTempSpinBox.value
    // KCM 框架注入的其他页面配置属性（忽略）
    property double cfg_updateInterval
    property double cfg_updateIntervalDefault

    QtObject {
        id: d

        property string osId: "tux"

        Component.onCompleted: {
            Code.getDistroInfo(function(arrayResult) {
                osId = arrayResult["id"];
            }, this)
        }
    }

    onCfg_bgColorChanged: {
        switch (cfg_bgColor) {
        default: case 0: bgColorTypeGroup.checkedButton = standardBgColor; break;
        case 1: bgColorTypeGroup.checkedButton = crystalBgColor; break;
        case 2: bgColorTypeGroup.checkedButton = translucentBgColor; break;
        }
    }

    onCfg_tempUnitChanged: {
        switch (cfg_tempUnit) {
        default: case 0: tempUnitTypeGroup.checkedButton = celsiusTemp; break;
        case 1: tempUnitTypeGroup.checkedButton = fahrenheitTemp; break;
        }
    }

    Component.onCompleted: {
        cfg_bgColorChanged();
        cfg_tempUnitChanged();
    }

    Controls.ButtonGroup {
        id: bgColorTypeGroup
    }

    Controls.ButtonGroup {
        id: tempUnitTypeGroup
    }

    ColumnLayout {
        id: settingsLayout
        anchors.fill: parent

        Controls.GroupBox {
            title: i18n("Display settings:")
            Layout.fillWidth: true

            GridLayout {
                columns: 2

                Controls.Label {
                    text: i18n("Logo:")
                    Layout.alignment: Qt.AlignRight
                    Layout.row: 0
                    Layout.column: 0
                }

                Controls.ComboBox {
                    id: logoComboBox
                    model: [i18n("Default"), i18n("Tux"), i18n("Slackware"), i18n("Ubuntu"), i18n("Kubuntu"), i18n("OpenSUSE"), i18n("Manjaro"), i18n("Arch"), i18n("Fedora")]
                    Layout.row: 0
                    Layout.column: 1
                }

                Rectangle {

                    Layout.columnSpan: 2
                    Layout.alignment: Qt.AlignLeft
                    Layout.row: 1
                    Layout.column: 1

                    implicitHeight: logoImage.height + 10
                    implicitWidth:  logoComboBox.width + 10

                    color: "transparent"
                    border { width: 1; color: Kirigami.Theme.textColor }
                    radius: 2

                    Image {
                        id: logoImage

                        anchors.centerIn: parent

                        source: "../" + Code.getStandardLogo(logoComboBox.currentIndex, d.osId)
                        sourceSize.height: 100
                    }
                }

                Controls.Label {
                    text: i18n("Background color:")
                    Layout.alignment: Qt.AlignRight
                    Layout.row: 2
                    Layout.column: 0
                }

                Controls.RadioButton {
                    id: standardBgColor
                    Controls.ButtonGroup.group: bgColorTypeGroup
                    text: i18n("Standard")
                    onCheckedChanged: if (checked) cfg_bgColor = 0;
                    Layout.row: 2
                    Layout.column: 1
                }

                Controls.RadioButton {
                    id: crystalBgColor
                    Controls.ButtonGroup.group: bgColorTypeGroup
                    text: i18n("Crystal")
                    onCheckedChanged: if (checked) cfg_bgColor = 1;
                    Layout.row: 3
                    Layout.column: 1
                }

                Controls.RadioButton {
                    id: translucentBgColor
                    Controls.ButtonGroup.group: bgColorTypeGroup
                    text: i18n("Translucent")
                    onCheckedChanged: if (checked) cfg_bgColor = 2;
                    Layout.row: 4
                    Layout.column: 1
                }

                Controls.Label {
                    text: i18n("Show:")
                    Layout.alignment: Qt.AlignRight
                    Layout.row: 5
                    Layout.column: 0
                }

                Controls.CheckBox {
                    id: showGpuTempCheckBox
                    text: i18n("GPU Temperature")
                    Layout.row: 5
                    Layout.column: 1
                }

                Controls.CheckBox {
                    id: showSwapCheckBox
                    text: i18n("Swap")
                    Layout.row: 6
                    Layout.column: 1
                }

                Controls.CheckBox {
                    id: showUptimeCheckBox
                    text: i18n("Uptime")
                    Layout.row: 7
                    Layout.column: 1
                }
            }
        }

        Controls.GroupBox {
            title: i18n("Temperature settings:")
            Layout.fillWidth: true

            GridLayout {
                columns: 3
                rowSpacing: 2

                Controls.Label {
                    Layout.row: 0
                    Layout.column: 0
                    Layout.columnSpan: 3
                    text: i18n("<i>(You can use the <strong>sensors</strong> command to place the appropriate values ​​for this section.)</i>")
                    color: Kirigami.Theme.highlightColor
                    wrapMode: Text.WordWrap
                }

                Controls.Label {
                    text: i18n("Temperature units:")
                    Layout.alignment: Qt.AlignRight
                    Layout.row: 1
                    Layout.column: 0
                }

                Controls.RadioButton {
                    id: celsiusTemp
                    Controls.ButtonGroup.group: tempUnitTypeGroup
                    text: i18n("Celsius °C")
                    onCheckedChanged: if (checked) cfg_tempUnit = 0;
                    Layout.row: 1
                    Layout.column: 1
                }

                Controls.RadioButton {
                    id: fahrenheitTemp
                    Controls.ButtonGroup.group: tempUnitTypeGroup
                    text: i18n("Fahrenheit °F")
                    onCheckedChanged: if (checked) cfg_tempUnit = 1;
                    Layout.row: 2
                    Layout.column: 1
                }

                Controls.Label {
                    text: i18n("CPU High Temperature:")
                    Layout.alignment: Qt.AlignRight
                    Layout.row: 3
                    Layout.column: 0
                }

                Controls.SpinBox {
                    id: cpuHighTempSpinBox
                    Layout.row: 3
                    Layout.column: 1
                }

                Controls.Label {
                    text: i18n("CPU Critical Temperature:")
                    Layout.alignment: Qt.AlignRight
                    Layout.row: 4
                    Layout.column: 0
                }

                Controls.SpinBox {
                    id: cpuCritTempSpinBox
                    to: 150
                    Layout.row: 4
                    Layout.column: 1
                }
            }
        }

        Rectangle {
            Layout.fillHeight: true
            color: "transparent"
        }
    }
}
