import QtQuick 2.4
import Ubuntu.Components 1.3
import QtQuick.XmlListModel 2.0
import QtMultimedia 5.6

import "../components"
import "../components/shoutcast.js" as Shoutcast
import "../components/Util.js" as Util

Page {
    id: stationsPage
    objectName: "StationsPage"

    property string genreName: ""
    property string genreId: ""
    property int currentItem: -1

    property bool showBusy: false
    property var tuneinBase: ({})

    header: PageHeader {
        id: pageHeader
        title: i18n.tr("Stations for: ") + genreName
        StyleHints {
            foregroundColor: UbuntuColors.orange
            backgroundColor: UbuntuColors.porcelain
            dividerColor: UbuntuColors.slate
        }
        /*Rectangle {
            anchors.fill: parent
            color: UbuntuColors.porcelain
            Label {
                anchors.centerIn: parent
                text: pageHeader.title
                color: UbuntuColors.orange
            }
            Button {
                anchors.right: parent.right
                //anchors.verticalCenter: parent // not working
                text: "play/pause"
                color: "white"
                onClicked: pause()
            }
        }*/

        leadingActionBar.actions: [
            Action {
                iconName: "back"
                text: i18n.tr("Back")
                onTriggered: pageStack.pop();
            }
        ]
    }

    Column {
       spacing: units.gu(1)
       id: pageLayout
       anchors {
           margins: units.gu(2)
           fill: parent
       }

        Label {
            id: label
            objectName: "label"
            anchors {
                horizontalCenter: parent.horizontalCenter
                //top: pageHeader.bottom
                topMargin: units.gu(2)
            }

            text: i18n.tr("SHOUTcast")
        }

        ListView {
            id: stationsListView
            width: parent.width
            height: parent.height - label.height

            anchors {
                horizontalCenter: parent.horizontalCenter
                //top: label.bottom
                topMargin: units.gu(2)
            }
            delegate: ListItem {
                id: delegate
                width: parent.width //- 2*Theme.paddingMedium
                height: stationListItemView.height
                //x: Theme.paddingMedium
                //contentHeight: childrenRect.height

                StationListItemView {
                    id: stationListItemView
                }

                onClicked: loadStation(model.id, Shoutcast.createInfo(model), tuneinBase)
            }

            model: stationsModel.model

        }

        Scrollbar {
            flickableItem: stationsListView
            align: Qt.AlignTrailing
        }

    }

    JSONListModel {
        id: stationsModel
        source: getStationByGenreURI(genreId)
        query: "$..station"
        keepQuery: "$..tunein"
        orderField: "lc"
    }

    onGenreIdChanged: {
        showBusy = true
        stationsModel.model.clear()
    }

    function reload() {
        showBusy = true
        stationsModel.refresh()
    }

    Connections {
        target: stationsModel
        onLoaded: {
            showBusy = false
            currentItem = -1
            tuneinBase = {}
            var b = stationsModel.keepObject[0]["base"]
            if(b)
                tuneinBase["base"] = b
            b = stationsModel.keepObject[0]["base-m3u"]
            if(b)
                tuneinBase["base-m3u"] = b
            b = stationsModel.keepObject[0]["base-xspf"]
            if(b)
                tuneinBase["base-xspf"] = b
            loadingDone()
        }
        onTimeout: {
            //app.showErrorDialog(qsTr("SHOUTcast server did not respond"))
            console.log("SHOUTcast server did not respond")
        }
    }
}


