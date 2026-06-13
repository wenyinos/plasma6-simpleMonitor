cmake_minimum_required(VERSION 3.16)

project(plasma-simpleMonitor)

find_package(ECM REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR} ${CMAKE_MODULE_PATH})

find_package(KF6 REQUIRED COMPONENTS Plasma)
find_package(Plasma REQUIRED)

add_subdirectory(translations)

plasma_install_package(plasmoid org.kde.simpleMonitor)
