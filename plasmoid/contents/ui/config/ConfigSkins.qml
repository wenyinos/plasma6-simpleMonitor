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

import "../../code/code.js" as Code

KCM.SimpleKCM {
    id: root

    property alias cfg_skin: skinComboBox.currentIndex

    ColumnLayout {
        id: settingsLayout

        spacing: 2

        Row {
            spacing: 3

            Controls.Label {
                text: i18n("Skin:")
                anchors.verticalCenter: skinComboBox.verticalCenter
            }

            Controls.ComboBox {
                id: skinComboBox
                model: [i18n("Default"), i18n("Column")]

                onCurrentIndexChanged: {
                    switch (currentIndex)  {
                    default:
                        print("unknown skinComboBox.currentIndex")
                        // fall through
                    case 0:
                        skinImage.source = "../../images/defaultSkin-preview.png"
                        break
                    case 1:
                        skinImage.source = "../../images/columnSkin-preview.png"
                        break
                    case 2:
                        skinImage.source = "../../images/minimalisticSkin-preview.png"
                        break
                    }
                }
            }
        }

        Controls.Label {
            text: i18n("Preview:")
        }

        Image {
            id: skinImage
        }
    }
}
