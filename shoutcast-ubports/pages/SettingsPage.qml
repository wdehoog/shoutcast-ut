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
    }
}
