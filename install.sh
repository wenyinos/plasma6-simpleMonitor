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

# Install translation files.
for mo in $(find ./translations -name "*.mo" 2>/dev/null); do
    langpath=$(echo "$mo" | sed 's|./translations/||')
    dest="${HOME}/.local/share/locale/${langpath}"
    mkdir -p "$(dirname "$dest")"
    cp "$mo" "$dest"
done

# Ensure data script is executable
chmod +x ~/.local/share/plasma/plasmoids/org.kde.simpleMonitor/contents/code/data.sh 2>/dev/null
