TEMPLATE = aux
TARGET = shoutcast-ubports

RESOURCES += shoutcast-ubports.qrc

QML_FILES += \
    Main.qml

QML_COMPONENT_FILES = \
    components/JSONListModel.qml \
    components/StationListItemView.qml \
    components/StationListItemViewWithImage.qml \
    components/jsonpath.js \
    components/shoutcast.js \
    components/JSONListModel.qml \
    components/PlayerArea.qml \
    components/SwipeArea.qml \
    components/Util.js

QML_PAGE_FILES = \
    pages/AboutPage.qml \
    pages/GenrePage.qml \
    pages/HelpPage.qml \
    pages/SubGenrePage.qml \
    pages/Top500Page.qml \
    pages/SettingsPage.qml \
    pages/SearchPage.qml \
    pages/StationsPage.qml

RESOURCE_FILES = \
    resources/chevrons-up.svg \
    resources/folder.svg \
    resources/search.svg

CONF_FILES +=  shoutcast-ubports.apparmor \
               shoutcast-ubports.svg

AP_TEST_FILES += tests/autopilot/run \
                 $$files(tests/*.py,true)               

OTHER_FILES += $${CONF_FILES} \
               $${QML_FILES} \
               $${AP_TEST_FILES} \
               shoutcast-ubports.desktop

#specify where the qml/js files are installed to
qml_files.path += /shoutcast-ubports
qml_files.files += $${QML_FILES}

#specify where the qml/js files are installed to
qml_component_files.path += /shoutcast-ubports/components
qml_component_files.files += $${QML_COMPONENT_FILES}

#specify where the qml/js files are installed to
qml_page_files.path += /shoutcast-ubports/pages
qml_page_files.files += $${QML_PAGE_FILES}

#specify where the resource files are installed to
resource_files.path += /shoutcast-ubports/resources
resource_files.files += $${RESOURCE_FILES}

#specify where the config files are installed to
config_files.path = /shoutcast-ubports
config_files.files += $${CONF_FILES}

#install the desktop file, a translated version is 
#automatically created in the build directory
desktop_file.path = /shoutcast-ubports
desktop_file.files = $$OUT_PWD/shoutcast-ubports.desktop
desktop_file.CONFIG += no_check_exist

INSTALLS+=config_files qml_files qml_component_files qml_page_files resource_files desktop_file

DISTFILES += \
    components/JSONListModel.qml \
    components/jsonpath.js \
    components/shoutcast.js \
    components/Util.js \
    components/StationListItemView.qml \
    pages/Top500Page.qml \
    pages/GenrePage.qml \
    pages/SubGenrePage.qml \
    pages/StationsPage.qml \
    pages/AboutPage.qml \
    pages/SettingsPage.qml \
    pages/SearchPage.qml \
    components/StationListItemViewWithImage.qml \
    resources/chevrons-up.svg \
    resources/folder.svg \
    resources/search.svg \
    components/SwipeArea.qml \
    components/PlayerArea.qml \
    pages/HelpPage.qml \
    ../po/fr.po
