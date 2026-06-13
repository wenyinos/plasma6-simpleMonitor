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
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    id: root

    property alias cfg_coloredCpuLoad: coloredCpuLoadCheckBox.checked
    property alias cfg_flatCpuLoad: flatCpuLoadCheckBox.checked
    property alias cfg_indicatorHeight: indicatorHeightSpinBox.value
    property alias cfg_updateInterval: updateIntervalSlider.value

    ColumnLayout {
        id: settingsLayout
        anchors.fill: parent

        Controls.GroupBox {
            title: i18n("Style settings:")
            Layout.fillWidth: true

            GridLayout {
                columns: 2

                Controls.Label {
                    text: i18n("CPU load indicator style:")
                    Layout.alignment: Qt.AlignRight
                    Layout.row: 0
                    Layout.column: 0
                }

                Controls.CheckBox {
                    id: coloredCpuLoadCheckBox
                    text: i18n("Colored")
                    Layout.row: 0
                    Layout.column: 1
                }

                Controls.CheckBox {
                    id: flatCpuLoadCheckBox
                    text: i18n("Flat")
                    Layout.row: 1
                    Layout.column: 1
                }

                Controls.SpinBox {
                    id: indicatorHeightSpinBox
                    from: 1
                    to: 99
                    Layout.row: 2
                    Layout.column: 1
                }

                Controls.Label {
                    text: i18n("CPU load indicator height:")
                    Layout.alignment: Qt.AlignRight
                    Layout.row: 2
                    Layout.column: 0
                }
            }
        }

        Controls.GroupBox {
            title: i18n("Performance settings:")
            Layout.fillWidth: true

            GridLayout {
                columns: 3

                Controls.Label {
                    text: i18n('Update interval:')
                    Layout.alignment: Qt.AlignRight
                }

                // Plasma 6 的 SpinBox 不支持小数，用 Slider 替代
                Controls.Slider {
                    id: updateIntervalSlider
                    from: 0.1
                    to: 10.0
                    stepSize: 0.1
                    Layout.fillWidth: true
                }

                Controls.Label {
                    text: i18n("%1 s", updateIntervalSlider.value.toFixed(1))
                }
            }
        }

        Rectangle {
            Layout.fillHeight: true
            color: "transparent"
        }
    }
}
