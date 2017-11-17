import QtQuick 2.4
import Ubuntu.Components 1.3


import "../components"
import "../components/shoutcast.js" as Shoutcast
import "../components/Util.js" as Util

Page {
    id: settingsPage
    objectName: "SettingsPage"


    header: PageHeader {
        id: pageHeader
        title: i18n.tr("Settings")
        StyleHints {
            foregroundColor: UbuntuColors.orange
            backgroundColor: UbuntuColors.porcelain
            dividerColor: UbuntuColors.slate
        }
        flickable: flick
    }

    Flickable {
        id: flick
        anchors.fill: parent

        Column {
            id: column
            width: parent.width - 2 * units.gu(4)
            y: units.gu(2)
            x: units.gu(2)
            spacing: units.gu(2)

            Column {
                Label {
                    text: i18n.tr("Maximum number of results to ask the server (per query)")
                }

                TextField {
                    id: maxNumberOfResults
                    validator: IntValidator{bottom: 1; top: 65534;}
                    text: settings.max_number_of_results
                    onAccepted: settings.max_number_of_results = parseInt(text)
                }
            }

            Column {
                Label {
                    text: i18n.tr("Time to wait for response from server (seconds)")
                }

                TextField {
                    id: serverTimeout
                    validator: IntValidator{bottom: 1; top: 60;}
                    text: settings.server_timeout
                    onAccepted: settings.server_timeout = parseInt(text)
                }
            }
        }

    }
}
