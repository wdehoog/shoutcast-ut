import QtQuick 2.4
import Ubuntu.Components 1.3

Page {
    id: aboutPage
    objectName: "AboutPage"
    anchors.fill: parent
	property int marginColumn: units.gu(1)
	 
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
            
            width: flick.width - 2*marginColumn
            anchors.horizontalCenter: parent.horizontalCenter
            
            anchors.top: parent.top
            anchors.topMargin: units.gu(1) + pageHeader.height
            spacing: units.gu(5)

			UbuntuShape {
				id: icon
				width: units.gu(10)
				height: width
				anchors.horizontalCenter: parent.horizontalCenter
				radius: "medium"
				source: Image {
					source: Qt.resolvedUrl("../shoutcast-ubports.svg")
				}
			}
		
			Column {
				id: appTitleColumn
				spacing: units.gu(1)
				width: flick.width - 2*marginColumn
				anchors.horizontalCenter: parent.horizontalCenter

				Label {
					horizontalAlignment: Text.AlignHCenter
					font.pixelSize:FontUtils.sizeToPixels("large")
					font.bold: true
					text: "shoutcast-ubports 0.2"
					width: parent.width
					wrapMode: Text.WordWrap
				}

				Label {
					horizontalAlignment: Text.AlignHCenter
					font.pixelSize:FontUtils.sizeToPixels("large")
					text: i18n.tr("SHOUTcast player for UBPorts")
					width: parent.width
					wrapMode: Text.WordWrap
				}

				Label {
					horizontalAlignment: Text.AlignHCenter
					anchors.horizontalCenter: parent.horizontalCenter
					font.pixelSize:FontUtils.sizeToPixels("large")
					text: "Copyright (C) 2017 Willem-Jan de Hoog"
					width: parent.width
					wrapMode: Text.WordWrap
				}
				Label {
					horizontalAlignment: Text.AlignHCenter
					anchors.horizontalCenter: parent.horizontalCenter
					font.pixelSize:FontUtils.sizeToPixels("medium")
					text: i18n.tr("sources: <a href='https://github.com/wdehoog/shoutcast-ubports'>github.com/wdehoog/shoutcast-ubports</a>")
					width: parent.width
					wrapMode: Text.WordWrap
					onLinkActivated: Qt.openUrlExternally(link)
				}
				Label {
					horizontalAlignment: implicitWidth > width ? Text.AlignLeft : Text.AlignHCenter
					anchors.horizontalCenter: parent.horizontalCenter
					font.pixelSize:FontUtils.sizeToPixels("medium")
					text: i18n.tr("License: MIT")
					width: parent.width
					wrapMode: Text.WordWrap
				}
			}



            Column {
                width: parent.width - 4*marginColumn
				anchors.horizontalCenter: parent.horizontalCenter
				
                Label {
                    text: i18n.tr("Translations")
                }

                Label {
					width: parent.width
                    anchors {
                        left: parent.left
                        leftMargin: units.gu(2)
                    }
                    font.pixelSize:FontUtils.sizeToPixels("large")
                    wrapMode: Text.WordWrap
                    text: "<b>Anne017:</b> fr"
                    }
                    Label {
					width: parent.width
                    anchors {
                        left: parent.left
                        leftMargin: units.gu(2)
                    }
                    font.pixelSize:FontUtils.sizeToPixels("large")
                    wrapMode: Text.WordWrap
                    text: "<b>Joan CiberSheep:</b> ca"
                    }
            }

            Column {
                width: parent.width - 4*marginColumn
				anchors.horizontalCenter: parent.horizontalCenter

                Label {
                    text: i18n.tr("Thanks to")
                }

                Label {
					width: parent.width
                    anchors {
                        left: parent.left
                        leftMargin: units.gu(2)
                    }
                    font.pixelSize:FontUtils.sizeToPixels("large")
                    wrapMode: Text.WordWrap
                    text: "<b>SHOUTcast:</b> <a href='https://www.shoutcast.com'>shoutcast.com</a>"
                    onLinkActivated: Qt.openUrlExternally(link)
                }
                Label {
					width: parent.width
                    anchors {
                        left: parent.left
                        leftMargin: units.gu(2)
                    }
                    font.pixelSize:FontUtils.sizeToPixels("large")
                    wrapMode: Text.WordWrap
                    text: "<b>UBPorts Team:</b> <a href='https://ubports.com/'>UBPorts</a>"
                    onLinkActivated: Qt.openUrlExternally(link)
                }
                Label {
					width: parent.width
                    anchors {
                        left: parent.left
                        leftMargin: units.gu(2)
                    }
                    font.pixelSize:FontUtils.sizeToPixels("large")
                    wrapMode: Text.WordWrap
                    text: i18n.tr("<b>walidham:</b> UBPorts port for titan")
                }
                Label {
					width: parent.width
                    anchors {
                        left: parent.left
                        leftMargin: units.gu(2)
                    }
                    font.pixelSize:FontUtils.sizeToPixels("large")
                    wrapMode: Text.WordWrap
                    text: "<b>Romain Pokrzywka:</b> JSONListModel"
                }
                Label {
					width: parent.width
                    anchors {
                        left: parent.left
                        leftMargin: units.gu(2)
                    }
                    font.pixelSize:FontUtils.sizeToPixels("large")
                    wrapMode: Text.WordWrap
                    text: "<b>Stefan Goessner:</b> JSONPath"
                }
                Label {
					width: parent.width
                    anchors {
                        left: parent.left
                        leftMargin: units.gu(2)
                    }
                    font.pixelSize:FontUtils.sizeToPixels("large")
                    wrapMode: Text.WordWrap
                    text: i18n.tr("<b>igh0zt:</b> app icon")
                }
                Label {
					width: parent.width
                    anchors {
                        left: parent.left
                        leftMargin: units.gu(2)
                    }
                    font.pixelSize:FontUtils.sizeToPixels("large")
                    wrapMode: Text.WordWrap
                    text: "<b>feathericons.com:</b> <a href='https://feathericons.com/'>some icons</a>"
                    onLinkActivated: Qt.openUrlExternally(link)
                }
                Label {
					width: parent.width
                    anchors {
                        left: parent.left
                        leftMargin: units.gu(2)
                    }
                    font.pixelSize:FontUtils.sizeToPixels("large")
                    wrapMode: Text.WordWrap
                    text: i18n.tr("<b>Canonical:</b> ubuntu-touch. Why did you stop?")
                }
            }
        }
	}
}

