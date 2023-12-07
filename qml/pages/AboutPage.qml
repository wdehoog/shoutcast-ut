import QtQuick 2.4
import Lomiri.Components 1.3
import Lomiri.Components.Themes 1.3

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

                LomiriShape {
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
                        text: "shoutcast-ut 0.6"
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
                        text: i18n.tr("sources:") + "<a href=\"https://github.com/wdehoog/shoutcast-ut\">https://github.com/wdehoog/shoutcast-ut</a>"
                        onLinkActivated: Qt.openUrlExternally(link)
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
"Advocatux: es<br>"
+ "Anne017: fr<br>"
+ "Joan CiberSheep: ca<br>"
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
"SHOUTcast: <a href=\"https://www.shoutcast.com/\">www.shoutcast.com</a> <br>"
+"UT Team: Ubuntu Touch<br>"
+"Romain Pokrzywka: JSONListModel<br>"
+"Stefan Goessner: JSONPath<br>"
+"Joan CiberSheep: app icon<br>"
+"<a href=\"https://feathericons.com/\">feathericons.com</a>: some icons<br>"
+"Canonical: ubuntu-touch. Why did you stop?<br>"
                    onLinkActivated: Qt.openUrlExternally(link)
                }
            }
        }
    }
}
