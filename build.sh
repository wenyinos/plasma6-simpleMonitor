#!/bin/bash

cd "${0%/*}"
kpackagetool6 -t Plasma/Applet -r org.kde.simpleMonitor 2>/dev/null
kpackagetool6 -t Plasma/Applet -i ./plasmoid
kbuildsycoca6 --noincremental
plasmoidviewer6 -a org.kde.simpleMonitor
