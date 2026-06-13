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

Item {
    id: root
    property real fillScale: 1.0
    property bool editMode: false

    // Expose image as a property so skins can set image.source
    property alias image: img

    Image {
        id: img
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
    }

    Rectangle {
        parent: img
        anchors.fill: parent
        visible: editMode
        color: "transparent"
        border.width: 1
        border.color: "black"

        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            color: "transparent"
            border.width: 1
            border.color: "white"
        }

        Image {
            anchors {
                right: parent.right
                top: parent.top
            }
            source: "../../images/resize.svg"
            sourceSize: Qt.size(10,10)

            MouseArea {
                id: resizeArea
                anchors.fill: parent

                property bool resizeEvent: false

                state: "NORMAL"
                states: [
                    State {
                        name: "NORMAL"
                        PropertyChanges {
                            target: resizeArea
                            cursorShape: Qt.ArrowCursor
                        }
                    },
                    State {
                        name: "RESIZE"
                        PropertyChanges {
                            target: resizeArea
                            cursorShape: Qt.SizeBDiagCursor
                        }
                    }
                ]

                onPressed: {
                    resizeEvent = true
                }

                onPositionChanged: {
                    if (resizeEvent) {
                        var mousePoint = mapToItem(root, mouse.x, mouse.y);
                        root.fillScale = Math.min(Math.max(0.3, Math.max(2*mousePoint.x/root.width - 1.0, 1.0 - 2*mousePoint.y/root.height)), 1.0)
                    }
                }

                onReleased: {
                    resizeEvent = false
                }
            }
        }
    }
}
