import QtQuick 2.4
import Ubuntu.Components 1.3
import QtMultimedia 5.6

import "./" // to use local SwipeArea

Row {
    property int audioPlaybackState

    signal pause()
    signal previous()
    signal next()

    id: playerUI
    anchors {
        bottom: parent.bottom
        bottomMargin: units.gu(1)
    }
    width: parent.width - 2*units.gu(1)
    x: units.gu(1)

    SwipeArea {
        width: parent.width - playerButton.width
        height: childrenRect.height
        anchors.bottom: parent.bottom
        z: 1

        Row {
            width: parent.width
            anchors.bottom: parent.bottom

            Icon {
                id: imageItem
                source: logoURL.length > 0 ? logoURL : defaultImageSource
                width: units.gu(10)
                height: width
                anchors.verticalCenter: parent.verticalCenter
                //fillMode: Image.PreserveAspectFit
            }

            Column {
                id: meta
                width: parent.width - imageItem.width
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    id: m1
                    x: units.gu(1)
                    width: parent.width - units.gu(1)
                    font.bold: true
                    color: UbuntuColors.orange
                    wrapMode: Text.Wrap
                    text: streamMetaText1
                }
                Text {
                    id: m2
                    x: units.gu(1)
                    width: parent.width - units.gu(1)
                    anchors.right: parent.right
                    wrapMode: Text.Wrap
                    font.bold: true
                    color: UbuntuColors.darkGrey
                    text: streamMetaText2
                }

            }
        }

        onSwiped: {
            console.log("onSwiped leftToRight=" + leftToRight)
            if(leftToRight)
                next()
            else
                previous()
        }
    }

    Button {
        id: playerButton
        width: units.gu(4)
        height: width
        anchors.verticalCenter: parent.verticalCenter
        //color: UbuntuColors.porcelain


        action: Action {
              //iconName: audioPlaybackState == Audio.PlayingState ? "media-playback-pause" : "media-playback-start"
              iconSource: audioPlaybackState == Audio.PlayingState
                            ? Qt.resolvedUrl("../resources/pause.svg")
                            : Qt.resolvedUrl("../resources/play.svg")
              //text: i18n.tr("Pause")
              onTriggered: pause()
        }
    }

}
