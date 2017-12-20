import QtQuick 2.4
import Ubuntu.Components 1.3


Page {
    id: helpPage
    objectName: "HelpPage"


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
        anchors.fill: parent
        anchors.margins: units.gu(1)

        Column {
            width: flick.width
            //height: childrenRect.height

            Label {
                width: parent.width
                font.pixelSize:FontUtils.sizeToPixels("large")
                wrapMode: Text.WordWrap
                textFormat: TextEdit.RichText
                text:
// weird formatting with "\n \" to keep it readable here and in the po(t) files
i18n.tr("<p>This app allows to browse the <b>SHOUTcast</b> database and tune in on internet radio stations.</p>\n \
<p>The different pages allow to:</p>\n \
<ul>\n \
  <li>Browse by Genre</li>\n \
  <li>List the Top 500 stations</li>\n \
  <li>Search by 'Now Playing' or Keywords</li>\n \
  <li>Configure the app</li>\n \
</ul>\n \
<p>The player area at the bottom allows to pause/play a stream en by horizontal swiping\n \
to navigate the stations list (next/previous).</p>\n \
<p>Main Issues:</p>\n \
<ul>\n \
  <li>If there is no network then you are toast</li>\n \
  <li>The stations lists can show the logos (see the Settings page) but it makes the app crash a lot.</li>\n \
  <li>The app checks if the Audio object has meta data available like current track info but appearently\n \
      this is not implemented in UBPorts. See https://bugs.launchpad.net/bugs/1586230.</i>\n \
</ul><br>\n \
")
            }

            Label {
                width: parent.width
                font.pixelSize:FontUtils.sizeToPixels("large")
                wrapMode: Text.WordWrap
                textFormat: TextEdit.RichText
                onLinkActivated: Qt.openUrlExternally(link)
                text:

// weird formatting with "\n \" to keep it readable here and in the po(t) files
i18n.tr("<p>The sources can be found on GitHub:\n \
<a href=\"https://github.com/wdehoog/shoutcast-ubports\">https://github.com/wdehoog/shoutcast-ubports</a>.</p>\n \
<p>Please report any issues on the GitHub Issue page:\n \
<a href=\"https://github.com/wdehoog/shoutcast-ubports/issues\">https://github.com/wdehoog/shoutcast-ubports/issues</a>.</p>")
            }
        }

    }

}
