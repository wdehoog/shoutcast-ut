import QtQuick 2.4
import Ubuntu.Components 1.3


import "../components"
import "../components/shoutcast.js" as Shoutcast
import "../components/Util.js" as Util

Page {
    id: aboutPage
    objectName: "AboutPage"


    header: PageHeader {
        id: pageHeader
        title: i18n.tr("About SHOUTcast")
        StyleHints {
            foregroundColor: UbuntuColors.orange
            backgroundColor: UbuntuColors.porcelain
            dividerColor: UbuntuColors.slate
        }
        flickable: flick.flickableItem
    }

    ScrollView  {
        id: flick
        anchors.fill: parent

        Column {
            id: column
            width: flick.width - 2*units.gu(1)
            x: units.gu(1)
            y: x
            spacing: units.gu(10)

            Item {
                width: parent.width
                height: childrenRect.height

                Icon {
                    id: icon
                    width: units.gu(10)
                    height: width
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: Qt.resolvedUrl("../shoutcast-ubports.png")
                }

                Column {
                    id: appTitleColumn

                    anchors {
                        left: parent.left
                        leftMargin: Theme.horizontalPageMargin
                        right: parent.right
                        rightMargin: Theme.horizontalPageMargin
                        top: icon.bottom
                        topMargin: Theme.paddingMedium
                    }

                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize:FontUtils.sizeToPixels("large")
                        text: "shoutcast-ubports 0.1"
                    }

                    Label {
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize:FontUtils.sizeToPixels("large")
                        text: "SHOUTcast player for UBPorts"
                        width: parent.width
                        wrapMode: Text.WordWrap
                    }

                    Label {
                        horizontalAlignment: implicitWidth > width ? Text.AlignLeft : Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize:FontUtils.sizeToPixels("large")
                        text: "Copyright (C) 2017 Willem-Jan de Hoog"
                        width: parent.width
                    }
                    Label {
                        horizontalAlignment: implicitWidth > width ? Text.AlignLeft : Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize:FontUtils.sizeToPixels("medium")
                        text: "sources: https://github.com/wdehoog/shoutcast-ubports"
                        width: parent.width
                    }
                    Label {
                        horizontalAlignment: implicitWidth > width ? Text.AlignLeft : Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize:FontUtils.sizeToPixels("medium")
                        text: "License: MIT"
                        width: parent.width
                    }
                }

            }

            Column {
                width: parent.width

                Label {
                    text: "Thanks to"
                }

                Label {
                    anchors {
                        left: parent.left
                        leftMargin: units.gu(2)
                        right: parent.right
                        rightMargin: units.gu(2)
                    }
                    font.pixelSize:FontUtils.sizeToPixels("large")
                    wrapMode: Text.WordWrap
                    text:
"SHOUTcast: www.shoutcast.com
UBPorts Team: UBPorts
walidham: UBPorts port for titan
Romain Pokrzywka: JSONListModel
Stefan Goessner: JSONPath
igh0zt: app icon
https://feathericons.com/: some icons
Canonical: ubuntu-touch. Why did you stop?"
                }
            }
        }
    }
}
