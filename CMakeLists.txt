cmake_minimum_required(VERSION 3.21)

project(WifiWindow LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup()
qt_policy(SET QTP0001 NEW)
qt_policy(SET QTP0004 NEW)

# Temporary entry point for testing purposes
qt_add_executable(WifiWindow
	main.cpp
)

qt_add_qml_module(
	WifiWindow
	URI WifiWindow
	VERSION 1.0
	NO_CACHEGEN
	NO_GENERATE_QMLDIR

	QML_FILES
	        qml/Main.qml
		qml/screens/WifiConfigScreen.qml

		qml/components/Badge.qml
		qml/components/Banner.qml
		qml/components/Button.qml
		qml/components/Input.qml
		qml/components/ListItem.qml
		qml/components/NetworkRow.qml
		qml/components/StatusBadge.qml

		qml/tokens/Colors.qml
		qml/tokens/FontStyle.qml
		qml/tokens/Spacing.qml
		qml/tokens/Typography.qml

	RESOURCES
		qml/qmldir
		qml/tokens/qmldir
		qml/components/qmldir
		qml/screens/qmldir
		qml/icons/alert-red.svg
		qml/icons/alert-yellow.svg
		qml/icons/checkmark-connected.svg
		qml/icons/chevron-down.svg
		qml/icons/chevron-up.svg
		qml/icons/connect.svg
		qml/icons/eye-hidden.svg
		qml/icons/eye-visible.svg
		qml/icons/info-blue.svg
		qml/icons/lock.svg
		qml/icons/network-active.svg
		qml/icons/network-default.svg
		qml/icons/scan.svg
		qml/icons/signal-full.svg
		qml/icons/status-check.svg
		qml/icons/status-shield.svg
		qml/icons/wifi.svg

	SOURCES
	    src/controllers/WifiController.h
		src/interfaces/IWiFiManager.h
		src/managers/MockWiFiManager.h
		src/managers/WiFiLinuxManager.h
		src/managers/WiFiWindowsManager.h
		src/services/WiFiService.cpp
		src/services/WiFiService.h
)

set_source_files_properties(
    qml/tokens/Colors.qml
    qml/tokens/Spacing.qml
    qml/tokens/Typography.qml
    PROPERTIES
        QT_QML_SINGLETON_TYPE TRUE
)

target_include_directories(WifiWindow PRIVATE
    "${CMAKE_CURRENT_LIST_DIR}/src"
)

target_link_libraries(WifiWindow PRIVATE
	Qt6::Quick
)
