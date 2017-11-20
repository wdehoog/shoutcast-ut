import QtQuick 2.4
import Ubuntu.Components 1.3

import "shoutcast.js" as Shoutcast

Row {
    height: units.gu(7)

    /*Image {
        id: image
        anchors {
            verticalCenter: parent.verticalCenter
            rightMargin: units.gu(1)
        }
        asynchronous: true
        fillMode: Image.PreserveAspectFit
        height: units.gu(7)
        width: height
        source: logo ? logo : ""
    }*/
    Icon {
        id: image
        anchors {
            verticalCenter: parent.verticalCenter
            rightMargin: units.gu(1)
        }
        asynchronous: true
        //fillMode: Image.PreserveAspectFit
        height: units.gu(7)
        width: height
        source: logo ? logo : ""
    }

    // spacer
    Rectangle {
        width: units.gu(1)
        height: units.gu(7)
        opacity: 0
    }

    StationListItemView {
        id: stationInfo
        width: parent.width - units.gu(8)
    }
}

