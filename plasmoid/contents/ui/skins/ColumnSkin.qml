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

import "../monitorWidgets"
import "../components"
import "../../code/code.js" as Code

BaseSkin {
    id: root

    implicitWidth: mainLayout.implicitWidth + mainLayout.anchors.leftMargin + mainLayout.anchors.rightMargin
    implicitHeight: mainLayout.implicitHeight + mainLayout.anchors.topMargin + mainLayout.anchors.bottomMargin

    ColumnLayout {
        id: mainLayout

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 5
        spacing: 0

        // Row 0: Date + Uptime (same line)
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Math.max(datePicker.implicitHeight, uptimePicker.implicitHeight + 4)

            DatePicker {
                id: datePicker
                anchors.left: parent.left
            }

            UptimePicker {
                id: uptimePicker
                anchors.right: parent.right
                visible: showUptime
                uptime: root.uptime
            }
        }

        // Row 1: Time
        TimePicker {
            id: timePicker

            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: 10
            Layout.fillWidth: false
            Layout.topMargin: 2
        }

        // Rows 2-4: Logo + OS info + CPU temps (horizontal)
        GridLayout {
            columns: 2
            rows: 1
            columnSpacing: 4
            rowSpacing: 0

            Layout.fillWidth: true
            Layout.topMargin: 4

            // Logo + OS info (column 0)
            ColumnLayout {
                spacing: 2

                Layout.preferredWidth: 100
                Layout.maximumWidth: 140
                Layout.fillHeight: false

                LogoImage {
                    id: distroLogo

                    Layout.preferredWidth: 80
                    Layout.preferredHeight: 80
                    Layout.alignment: Qt.AlignCenter

                    image.source: "../" + Code.getStandardLogo(logo, confEngine.distroId)

                    fillScale: plasmoid.configuration.logoScale
                    onFillScaleChanged: if (fillScale !== plasmoid.configuration.logoScale) plasmoid.configuration.logoScale = fillScale

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.RightButton
                        onClicked: logoPopup.open(mouse.x, mouse.y)
                    }

                    Controls.Menu {
                        id: logoPopup

                        Controls.MenuItem {
                            text: distroLogo.editMode ? i18n("Lock image scaling") : i18n("Unlock image scaling")
                            onTriggered: distroLogo.editMode = !distroLogo.editMode
                        }
                    }
                }

                OsInfoItem {
                    id: osInfoItem

                    distroName: root.distroName
                    distroId: root.distroId
                    distroVersion: root.distroVersion
                    kernelName: root.kernelName
                    kernelVersion: root.kernelVersion

                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    Layout.topMargin: 2
                    Layout.fillWidth: true
                }
            }

            // CPU temps + GPU temps (column 1)
            GridLayout {
                columns: root.showGpuTemp ? 2 : 1
                columnSpacing: 4
                rowSpacing: 2

                Layout.fillWidth: true
                Layout.fillHeight: false

                CoreTempList {
                    id: coreTempList

                    model: coreTempModel
                    highTemp: cpuHighTemp
                    criticalTemp: cpuCritTemp
                    tempUnit: root.tempUnit
                    direction: root.direction

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumWidth: 60
                }

                GpuTempList {
                    id: gpuTempList

                    visible: root.showGpuTemp
                    model: gpuTempModel
                    highTemp: cpuHighTemp
                    criticalTemp: cpuCritTemp
                    tempUnit: root.tempUnit
                    direction: root.direction

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumWidth: 60
                }
            }
        }

        // Separator
        Rectangle {
            color: "white"

            Layout.fillWidth: true
            Layout.minimumHeight: 2
            Layout.maximumHeight: 2
            Layout.preferredHeight: 2
            Layout.topMargin: 4
        }

        // CPU usage bars
        CpuWidget {
            id: cpuList

            direction: root.direction

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.topMargin: 4
            Layout.minimumWidth: 60
            Layout.minimumHeight: 40
        }

        // Memory separator
        Rectangle {
            color: "white"

            Layout.fillWidth: true
            Layout.minimumHeight: 2
            Layout.maximumHeight: 2
            Layout.preferredHeight: 2
            Layout.topMargin: 4
        }

        // Memory
        MemArea {
            id: memArea

            memFree: root.memFree
            memTotal: root.memTotal
            memCached: root.memCached
            memUsed: root.memUsed
            memBuffers: root.memBuffers

            Layout.fillWidth: true
            Layout.topMargin: 2
            Layout.leftMargin: 10
            Layout.rightMargin: 5
            Layout.preferredHeight: implicitHeight
        }

        // Swap separator (optional)
        Rectangle {
            visible: showSwap
            color: "white"

            Layout.fillWidth: true
            Layout.minimumHeight: 2
            Layout.maximumHeight: 2
            Layout.preferredHeight: 2
            Layout.topMargin: 4
        }

        // Swap (optional)
        MemArea {
            id: swapArea

            visible: showSwap
            memTypeLabel: i18n("Swap:")
            memFree: root.swapFree
            memTotal: root.swapTotal
            memUsed: root.swapUsed

            Layout.fillWidth: true
            Layout.topMargin: 2
            Layout.leftMargin: 10
            Layout.rightMargin: 5
            Layout.preferredHeight: implicitHeight
        }
    }
}
