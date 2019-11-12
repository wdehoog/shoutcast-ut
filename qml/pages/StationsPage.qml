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

    property bool canGoNext: currentItem < (stationsModel.model.count-1)
    property bool canGoPrevious: currentItem > 0
    property int navDirection: 0 // 0: none, -x: prev, +x: next
    property var tuneinBase: {}

    property string genreName: ""
    property string genreId: ""
    property int currentItem: -1

    property bool showBusy: false

    header: PageHeader {
        id: pageHeader
        title: i18n.tr("Stations for: ") + genreName
        StyleHints {
            foregroundColor: UbuntuColors.orange
            backgroundColor: UbuntuColors.porcelain
            dividerColor: UbuntuColors.slate
        }

        leadingActionBar.actions: [
            Action {
                iconName: "back"
                text: "Back"
                onTriggered: {
                    app.loadLastList(stationsModel.model, currentItem, tuneinBase)
                    pageStack.pop()
                }
            }
        ]

        trailingActionBar.actions: [
            Action {
                iconName: "home"
                text: i18n.tr("Home")
                onTriggered: {
                    app.loadLastList(stationsModel.model, currentItem, tuneinBase)
                    pageStack.pop()
                    pageStack.pop()
                    pageStack.pop()
                }
            },
            Action {
                iconName: "reload"
                text: i18n.tr("Reload")
                onTriggered: reload()
            }
        ]

        flickable: stationsListView
    }

    ActivityIndicator {
        id: activity
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        running: showBusy
        visible: running
        z: 1
    }

    Column {
        id: pageLayout
        spacing: units.gu(1)
        anchors.fill: parent

        ListView {
            id: stationsListView
            width: parent.width - scrollBar.width
            height: parent.height
            anchors {
                horizontalCenter: parent.horizontalCenter
                topMargin: units.gu(2)
            }
            delegate: ListItem {
                id: delegate
                width: parent.width

                StationListItemView {
                    id: withoutImage
                    visible: !app.settings.show_station_logo_in_lists
                }

                StationListItemViewWithImage {
                    id: withImage
                    visible: app.settings.show_station_logo_in_lists
                }

                onClicked: loadStation(model.id, Shoutcast.createInfo(model), tuneinBase)
            }

            model: stationsModel.model

        }

        Scrollbar {
            id: scrollBar
            flickableItem: stationsListView
            //align: Qt.AlignTrailing
            anchors.right: parent.right
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

    function loadingDone() {
        if(stationsModel.model.count === 0) {
            app.showErrorDialog(qsTr("SHOUTcast server returned no Stations"))
            console.log("SHOUTcast server returned no Stations")
        } else
            currentItem = app.findStation(app.stationId, stationsModel.model)
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
            app.showErrorDialog(qsTr("SHOUTcast server did not respond"))
            console.log("SHOUTcast server did not respond")
        }
    }

    Connections {
        target: app

        onStationChanged: {
            navDirection = 0
            // station has changed look for the new current one
            currentItem = app.findStation(stationInfo.id, stationsModel.model)
        }

        onStationChangeFailed: {
            if(navDirection !== 0)
                navDirection = app.navToPrevNext(currentItem, navDirection, top500Model, tuneinBase)
        }

        onPrevious: {
            if(canGoPrevious) {
                navDirection = - 1
                var item = stationsModel.model.get(currentItem + navDirection)
                if(item)
                    app.loadStation(item.id, Shoutcast.createInfo(item), tuneinBase)
            }
        }

        onNext: {
            if(canGoNext) {
                navDirection = 1
                var item = stationsModel.model.get(currentItem + navDirection)
                if(item)
                     app.loadStation(item.id, Shoutcast.createInfo(item), tuneinBase)
            }
        }
    }

}


