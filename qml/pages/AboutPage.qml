import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Themes 1.3

import "../components"
import "../components/shoutcast.js" as Shoutcast
import "../components/Util.js" as Util

Page {
    id: aboutPage
    objectName: "AboutPage"


    header: PageHeader {
        id: pageHeader
        title: i18n.tr("About SHOUTcast")
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
            spacing: units.gu(5)

            Item {
                width: parent.width
                height: childrenRect.height

                UbuntuShape {
                    id: icon
                    width: units.gu(10)
                    height: width
                    anchors.horizontalCenter: parent.horizontalCenter
                    radius: "medium"
                    source: Image {
                        source: Qt.resolvedUrl("../resources/shoutcast-ut.svg")
                    }
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
                        text: "shoutcast-ut 0.5"
                    }

                    Label {
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize:FontUtils.sizeToPixels("large")
                        text: i18n.tr("SHOUTcast player for Ubuntu Touch")
                        width: parent.width
                        wrapMode: Text.WordWrap
                    }

                    Label {
                        horizontalAlignment: implicitWidth > width ? Text.AlignLeft : Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize:FontUtils.sizeToPixels("large")
                        text: "Copyright (C) 2020 Willem-Jan de Hoog"
                        width: parent.width
                    }
                    Label {
                        horizontalAlignment: implicitWidth > width ? Text.AlignLeft : Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize:FontUtils.sizeToPixels("medium")
                        text: i18n.tr("sources: https://github.com/wdehoog/shoutcast-ut")
                        width: parent.width
                    }
                    Label {
                        horizontalAlignment: implicitWidth > width ? Text.AlignLeft : Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize:FontUtils.sizeToPixels("medium")
                        text: i18n.tr("License: MIT")
                        width: parent.width
                    }
                }

            }

            Column {
                width: parent.width

                Label {
                    text: i18n.tr("Translations")
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
"Advocatux: es
Anne017: fr
Joan CiberSheep: ca"
                    }
            }

            Column {
                width: parent.width

                Label {
                    text: i18n.tr("Thanks to")
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
UT Team: Ubuntu Touch
Romain Pokrzywka: JSONListModel
Stefan Goessner: JSONPath
Joan CiberSheep: app icon
https://feathericons.com/: some icons
Canonical: ubuntu-touch. Why did you stop?"
                }
            }
        }
    }
}
