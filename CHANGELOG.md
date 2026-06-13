# plasma-simpleMonitor Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/).

## [Unreleased] - 2017-xx-xx
    ### Added
    - Turkish translation.

## [Unreleased] - 2017-xx-xx
    ### Added
    - Chinese(simplified) translation.
    - Polish translation.

    ### Fixed
    - Plasmoid logo path in .desktop file.

## [0.7] - 2026-06-13
    ### Added
    - Plasma 6 / KF6 native support.
    - KSystemStats sensor integration (CPU, memory, GPU, uptime).
    - GPU temperature fallback via nvidia-smi when KSystemStats sensor unavailable.
    - metadata.json (replaces metadata.desktop for Plasma 6).

    ### Changed
    - Migrated from Plasma 5 / KF5 to Plasma 6 / KF6.
    - Migrated from PlasmaCore.DataSource to org.kde.ksysguard.sensors.Sensor.
    - Migrated from Qt Quick Controls 1 to Qt Quick Controls 2.
    - ExclusiveGroup replaced with ButtonGroup.
    - SpinBox with decimal support replaced with Slider (update interval setting).
    - theme.highlightColor / theme.buttonTextColor replaced with Kirigami.Theme.
    - PlasmaComponents.ContextMenu replaced with Controls.Menu.
    - Removed units.devicePixelRatio scaling (Qt 6 handles high DPI automatically).
    - Removed version numbers from QML imports (Qt 6 convention).
    - backgroundHints uses Plasmoid attached property and PlasmaTypes enum.
    - CMakeLists.txt updated for KF6 (cmake >= 3.16, KF6Plasma).
    - plasmapkg2 replaced with kpackagetool6 in all scripts.
    - plasmoidviewer replaced with plasmoidviewer6.
    - kbuildsycoca5 replaced with kbuildsycoca6.
    - translations/Messages.sh reads from metadata.json.

    ### Fixed
    - Polish translation: corrected "mie" (Wednesday), "dic" (December), "Uptime:".
    - Russian translation: corrected "mie" (Wednesday), "dic" (December).
    - Turkish translation: corrected "mie" (Wednesday), "Uptime:" (was in Polish).
    - Chinese translation: corrected "mie" (Wednesday), "dic" (December), "Free:", "Logo:".

    ### Removed
    - Plasma 5 / KF5 support.
    - PlasmaCore.DataSource data engine dependency.
    - es_ES and eu_ES empty translation directories.

## [0.6] - 2017-03-19
    ### Added
    - Translation support.
    - ru translation.
    - SVG logo scaling.
    - Base support for RightToLeft view.
    - Logos for Fedora, Manjaro and Arch.
    - CMake support.
    - CMake installation instructions in README.
    - Script to cleanup after launch.sh.
    - CHANGELOG.

    ### Changed
    - SVG logos replaced PNG logos.

    ### Fixed
    - Plasmoid name and version in .desktop file.
    - Items positions.

    ## Removed
    - Tuz logo.

## [0.6-rc1] - 2017-02-07
    ### Added
    - Plasma 5 support.
    - Instructions for installation in README.
    - GPL LICENCE.
    - Skin support.
    - Column skin.
    - OpenSUSE logo.
    - Launch script to test plasmoids without install.

    ### Changed
    - Migrated from KDE4 to KF5.
    - Structure of project.
    - Migrated in development from .qmlproject to .pro file.
    - Config now base on .qml files.
    - QML now depend on quick 2.
    - Predefined CPU temperatures.

    ### Fixed
    - Additional plasmoid don't work with database.

    ## Removed
    - Plasma(KDE4) support.

## [0.5] - 2014-05-26
    ### Added
    - Fahrenheit support.
    - Visual improvements.
    - Plasma style support.

    ### Changed
    - LoadBar completed.

## [0.4] - 2013-12-28
    ### Fixed
    - Elements alignments.
    - Bad uptime.

## [0.3] - 2013-12-28
    ### Added
    - Background settings.
    - Logos for Kubuntu, Ubuntu and tuz.
    ### Changed
    - Detection of distro name.

    ### Fixed
    - Fonts.

## [0.2] - 2013-12-27
    ### Added
    - AMD K7 support for lmsensors.
    - Temperature settings.
    - README.

## [0.1] - 2013-12-27
    - Initial Commit.
