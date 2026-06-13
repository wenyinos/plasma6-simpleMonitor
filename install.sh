#!/bin/sh

cd "${0%/*}"

# Remove the Simple System Monitor plasmoid.
kpackagetool6 -t Plasma/Applet -r org.kde.simpleMonitor > /dev/null 2>&1

# Install the Simple System Monitor plasmoid.
kpackagetool6 -t Plasma/Applet -i ./plasmoid

# Install the Simple System Monitor icon.
ICON_PATH=${HOME}/.local/share/icons/hicolor/scalable/apps/
mkdir -p ${ICON_PATH}
cp plasmoid/contents/images/simpleMonitor_icon.svg ${ICON_PATH}
