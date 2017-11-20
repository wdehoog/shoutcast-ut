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

        Column {
            width: flick.width
            //height: childrenRect.height

            Label {
                width: parent.width
                font.pixelSize:FontUtils.sizeToPixels("large")
                wrapMode: Text.WordWrap
                textFormat: TextEdit.RichText
                text:
i18n.tr("<p>This app allows to browse the <b>SHOUTcast</b> database and tune in on internet radio stations.</p>

<p>The different pages allow to:</p>
<ul>
  <li>Browse by Genre</li>
  <li>List the Top 500 stations</li>
  <li>Search by 'Now Playing' or Keywords</li>
  <li>Configure the app</li>
</ul>

<p>The player area at the bottom allows to pause/play a stream en by horizontal swiping
to navigate the stations list (next/previous).</p>

<br><p>Main Issues:</p>
<ul>
  <li>If there is no network then you are toast</li>
  <li>The stations lists can show the logos (see the Settings page) but it makes the app crash a lot.</li>
  <li>The app checks if the Audio object has meta data available like current track info but appearently
      this is not implemented in UBPorts. See https://bugs.launchpad.net/bugs/1586230.</i>
</ul>
")
            }

            Label {
                width: parent.width
                font.pixelSize:FontUtils.sizeToPixels("large")
                wrapMode: Text.WordWrap
                textFormat: TextEdit.RichText
                onLinkActivated: Qt.openUrlExternally(link)
                text:
i18n.tr("<p>The sources can be found on GitHub:
<a href=\"https://github.com/wdehoog/shoutcast-ubports\">https://github.com/wdehoog/shoutcast-ubports</a>.</p>
<p>Please report any issues on the GitHub Issue page:
<a href=\"https://github.com/wdehoog/shoutcast-ubports/issues\">https://github.com/wdehoog/shoutcast-ubports/issues</a>.</p>")
            }
        }

    }

}
