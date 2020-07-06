import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.ListItems 1.3 as Old_ListItem

import "../components"
import "../components/shoutcast.js" as Shoutcast
import "../components/Util.js" as Util

Page {
    id: settingsPage
    objectName: "SettingsPage"

    property int mimeTypeFilter: app.settings.mime_type_filter

    onMimeTypeFilterChanged: {
        app.settings.mime_type_filter = mimeTypeFilter
    }

    header: PageHeader {
        id: pageHeader
        title: i18n.tr("Settings")
        flickable: flick
    }

    Flickable {
        id: flick
        anchors.fill: parent

        Column {
            id: column
            width: parent.width - units.gu(2)
            y: units.gu(1)
            x: units.gu(1)
            spacing: units.gu(2)

            Item {
                width: parent.width
                height: childrenRect.height
                Label {
                    width: parent.width - showStationLogos.width
                    wrapMode: Text.Wrap
                    text: i18n.tr("Show Station Logos in lists (crashes with large lists)")
                }
                Switch {
                    id: showStationLogos
                    anchors.right: parent.right
                    checked: settings.show_station_logo_in_lists
                    onCheckedChanged: settings.show_station_logo_in_lists = checked
                }
            }

            Column {
                width: parent.width
                Label {
                    width: parent.width
                    wrapMode: Label.Wrap
                    text: i18n.tr("Maximum number of results to ask the server (per query)")
                }
                TextField {
                    id: maxNumberOfResults
                    width: parent.width
                    validator: IntValidator{bottom: 1; top: 65534;}
                    text: settings.max_number_of_results
                    onAccepted: settings.max_number_of_results = parseInt(text)
                }
            }

            Column {
                width: parent.width
                Label {
                    width: parent.width
                    wrapMode: Text.Wrap
                    text: i18n.tr("Time to wait for response from server (seconds)")
                }
                TextField {
                    id: serverTimeout
                    width: parent.width
                    validator: IntValidator{bottom: 1; top: 60;}
                    text: settings.server_timeout
                    onAccepted: settings.server_timeout = parseInt(text)
                }
            }

            Column {
                width: parent.width
                Label {
                    text: i18n.tr("Mime Type Filter")
                    wrapMode: Text.Wrap
                    width: parent.width
                }
                Button {
                    id: popoverButton
                    width: parent.width
                    text: mimeTypeFilterLabels[mimeTypeFilter]
                    onClicked: PopupUtils.open(pocMimeTypeFilter, popoverButton)
                }
            }
        }

    }

    property var mimeTypeFilterLabels: [
        i18n.tr("No filter. Accept all mime types."),
        i18n.tr("Accept only MP3 (audio/mpeg)"),
        i18n.tr("Accept only AAC (audio/aacp)")
    ]

    ActionList {
        id: mimeTypeFilterActions
        Action {
            text: mimeTypeFilterLabels[0]
            onTriggered: mimeTypeFilter = 0
        }
        Action {
            text: mimeTypeFilterLabels[1]
            onTriggered: mimeTypeFilter = 1
        }
        Action {
            text: mimeTypeFilterLabels[2]
            onTriggered: mimeTypeFilter = 2
        }
    }

    Component {
        id: pocMimeTypeFilter
        ActionSelectionPopover {
            id: asp
            actions: mimeTypeFilterActions
            delegate: Old_ListItem.Standard {
                text: action.text
                onClicked: PopupUtils.close(asp)
            }
        }
    }
}
