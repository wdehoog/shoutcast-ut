import QtQuick 2.4
import Ubuntu.Components 1.3

Page {
    id: helpPage
    objectName: "HelpPage"
	anchors.fill: parent
	
	property int marginColumn: units.gu(1)

    header: PageHeader {
        id: pageHeader
        title: i18n.tr("SHOUTcast Help")
        StyleHints {
            foregroundColor: UbuntuColors.orange
            backgroundColor: UbuntuColors.porcelain
            dividerColor: UbuntuColors.slate
        }
        flickable: flick.flickableItem
    }

    ScrollView  {
        id: flick
        height: parent.height
        width: parent.width- 2*marginColumn
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        
        Column {
			id: mainColumn
			spacing: units.gu(5)
			anchors.top: parent.top
            anchors.topMargin: pageHeader.height

			Column {
				width: flick.width
				spacing: units.gu(1)

				Label {
					width: parent.width
					anchors.horizontalCenter: parent.horizontalCenter
					font.pixelSize:FontUtils.sizeToPixels("large")
					wrapMode: Text.WordWrap
					text: i18n.tr("This app allows to browse the <b>SHOUTcast</b> database and tune in on internet radio stations.")
				}
				Label {
					width: parent.width
					font.pixelSize:FontUtils.sizeToPixels("large")
					wrapMode: Text.WordWrap
					text: i18n.tr("The different pages allow to:")
				}
				Label {
					width: parent.width - units.gu(2)
					anchors.left: parent.left
					anchors.leftMargin: units.gu(2)
					font.pixelSize:FontUtils.sizeToPixels("large")
					wrapMode: Text.WordWrap
					text: i18n.tr("• Browse by Genre")
				}
				Label {
					width: parent.width - units.gu(2)
					anchors.left: parent.left
					anchors.leftMargin: units.gu(2)
					font.pixelSize:FontUtils.sizeToPixels("large")
					wrapMode: Text.WordWrap
					text: i18n.tr("• List the Top 500 stations")
				}
				Label {
					width: parent.width - units.gu(2)
					anchors.left: parent.left
					anchors.leftMargin: units.gu(2)
					font.pixelSize:FontUtils.sizeToPixels("large")
					wrapMode: Text.WordWrap
					text: i18n.tr("• Search by <i>Now Playing</i> or Keywords")
				}
				Label {
					width: parent.width - units.gu(2)
					anchors.left: parent.left
					anchors.leftMargin: units.gu(2)
					font.pixelSize:FontUtils.sizeToPixels("large")
					wrapMode: Text.WordWrap
					text: i18n.tr("• Configure the app")
				}
				Label {
					width: parent.width
					font.pixelSize:FontUtils.sizeToPixels("large")
					wrapMode: Text.WordWrap
					text: i18n.tr("The player area at the bottom allows to pause/play a stream en by horizontal swiping to navigate the stations list (next/previous).")
				}
			}
			Column {
				width: flick.width
				spacing: units.gu(1)
				
				Label {
					width: parent.width
					font.pixelSize:FontUtils.sizeToPixels("large")
					wrapMode: Text.WordWrap
					font.bold: true
					horizontalAlignment: Text.AlignHCenter
					text: i18n.tr("Main Issues:")
				}
				Label {
					width: parent.width - units.gu(2)
					anchors.left: parent.left
					anchors.leftMargin: units.gu(2)
					font.pixelSize:FontUtils.sizeToPixels("large")
					wrapMode: Text.WordWrap
					text: i18n.tr("• If there is no network then you are toast.")
				}
				Label {
					width: parent.width - units.gu(2)
					anchors.left: parent.left
					anchors.leftMargin: units.gu(2)
					font.pixelSize:FontUtils.sizeToPixels("large")
					wrapMode: Text.WordWrap
					text: i18n.tr("• The stations lists can show the logos (see the Settings page) but it makes the app crash a lot.")
				}
				Label {
					width: parent.width - units.gu(2)
					anchors.left: parent.left
					anchors.leftMargin: units.gu(2)
					font.pixelSize:FontUtils.sizeToPixels("large")
					wrapMode: Text.WordWrap
					text: i18n.tr("• The app checks if the Audio object has meta data available like current track info but appearently this is not implemented in UBPorts. See <a href='https://bugs.launchpad.net/bugs/1586230'>bug 1586230</a>.")
					onLinkActivated: Qt.openUrlExternally(link)
				}
			}
			Column {
				width: flick.width
				spacing: units.gu(2)
				
				Label {
					width: parent.width
					font.pixelSize:FontUtils.sizeToPixels("large")
					wrapMode: Text.WordWrap
					textFormat: TextEdit.RichText
					onLinkActivated: Qt.openUrlExternally(link)
					text: i18n.tr("<p>The sources can be found on GitHub: <a href=\"https://github.com/wdehoog/shoutcast-ubports\">github.com/wdehoog/shoutcast-ubports</a>.")
				}
				Label {
					width: parent.width
					font.pixelSize:FontUtils.sizeToPixels("large")
					wrapMode: Text.WordWrap
					textFormat: TextEdit.RichText
					onLinkActivated: Qt.openUrlExternally(link)
					text: i18n.tr("Please report any issues on: <a href='ttps://github.com/wdehoog/shoutcast-ubports/issues'>the GitHub Issue page</a>.")
				}
			}
		}
    }
}
