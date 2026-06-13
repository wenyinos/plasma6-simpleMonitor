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

    GridLayout {
        id: mainLayout

        anchors.fill: parent
        anchors.margins: 5
        columns: 3
        rows: 5
        columnSpacing: 0
        rowSpacing: 0

        // Row 0: Date + Uptime
        DatePicker {
            id: datePicker

            Layout.columnSpan: 1
            Layout.row: 0
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: 10
        }

        UptimePicker {
            id: uptimePicker

            visible: showUptime
            uptime: root.uptime

            Layout.row: 0
            Layout.column: 2
            Layout.alignment: Qt.AlignRight | Qt.AlignTop
            Layout.topMargin: 2
            Layout.rightMargin: 5
        }

        // Row 1: Time + CPU temps header
        TimePicker {
            id: timePicker

            Layout.row: 1
            Layout.column: 0
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: 10
            Layout.bottomMargin: 5
        }

        GridLayout {
            columns: root.showGpuTemp ? 2 : 1
            columnSpacing: 4
            rowSpacing: 2

            Layout.row: 1
            Layout.column: 1
            Layout.leftMargin: 5
            Layout.rightMargin: 5
            Layout.topMargin: 5
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

        CpuWidget {
            id: cpuList

            direction: root.direction

            Layout.row: 1
            Layout.column: 2
            Layout.leftMargin: 5
            Layout.topMargin: 5
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 60
        }

        // Row 2: Logo + OS info
        LogoImage {
            id: distroLogo

            Layout.row: 2
            Layout.column: 0
            Layout.preferredWidth: 100
            Layout.preferredHeight: 100
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 5

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

            Layout.row: 3
            Layout.column: 0
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.topMargin: 2
            Layout.fillWidth: true
        }

        // Row 4: Memory + Swap
        MemArea {
            id: memArea

            memFree: root.memFree
            memTotal: root.memTotal
            memCached: root.memCached
            memUsed: root.memUsed
            memBuffers: root.memBuffers

            Layout.row: 4
            Layout.column: 0
            Layout.topMargin: 2
            Layout.leftMargin: 10
            Layout.rightMargin: 5
            Layout.fillWidth: true
            Layout.preferredHeight: implicitHeight
        }

        MemArea {
            id: swapArea

            visible: showSwap
            memTypeLabel: i18n("Swap:")
            memFree: root.swapFree
            memTotal: root.swapTotal
            memUsed: root.swapUsed

            Layout.row: 5
            Layout.column: 0
            Layout.topMargin: 2
            Layout.leftMargin: 10
            Layout.rightMargin: 5
            Layout.fillWidth: true
            Layout.preferredHeight: implicitHeight
        }
    }
}
