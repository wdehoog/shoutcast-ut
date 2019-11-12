/*
  Copyright (C) 2019 Willem-Jan de Hoog
*/
import QtQuick 2.4
import Ubuntu.Components 1.3
import QtQuick.XmlListModel 2.0
import QtMultimedia 5.6

import "../components"
import "../components/shoutcast.js" as Shoutcast
import "../components/Util.js" as Util

Page {
    id: genrePage
    objectName: "GenrePage"

    property bool showBusy: false

    header: PageHeader {
        id: pageHeader
        title: i18n.tr("Genres")
        flickable: genresListView
    }

    JSONListModel {
        id: genresModel
        source: Shoutcast.PrimaryGenreBase + "?" + Shoutcast.DevKeyPart + "&" + Shoutcast.QueryFormat
        query: "$..genre.*"
    }

    function reload() {
        showBusy = true
        genresModel.refresh()
    }

    /*onStatusChanged: {
        if(status === PageStatus.Active)
            reload()
    }*/

    Connections {
        target: genresModel
        onLoaded: {
            showBusy = false
        }
        onTimeout: {
            showBusy = false
            app.showErrorDialog(qsTr("SHOUTcast server did not respond"))
            console.log("SHOUTcast server did not respond")
        }
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
            id: genresListView
            width: parent.width - scrollBar.width
            height: parent.height

            anchors {
                horizontalCenter: parent.horizontalCenter
                topMargin: units.gu(2)
            }

            delegate: ListItem {
                id: delegate
                width: parent.width //- 2*Theme.paddingMedium
                //height: stationListItemView.height
                //x: Theme.paddingMedium
                //contentHeight: childrenRect.height

                Column {
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter

                    Item {
                        width: parent.width
                        //height: nameLabel.height

                        Label {
                            id: nameLabel
                            textFormat: Text.StyledText
                            font.weight: Font.Bold
                            //truncationMode: TruncationMode.Fade
                            width: parent.width - countLabel.width
                            text: name ? name : qsTr("No Genre Name")
                        }
                        Label {
                            id: countLabel
                            anchors.right: parent.right
                            //font.pixelSize: Theme.fontSizeExtraSmall
                            text: count ? count : qsTr("?")

                        }
                    }

                }

                onClicked: {
                    var page
                    if(model.haschildren) {
                        // has sub genres
                        pageStack.push(Qt.resolvedUrl("SubGenrePage.qml"),
                                       {genreId: model.id, genreName: model.name})
                    } else {
                        // no sub genres
                        pageStack.push(Qt.resolvedUrl("StationsPage.qml"),
                                       {genreId: model.id, genreName: model.name})
                    }
                }
            }

            model: genresModel.model

        }

        Scrollbar {
            id: scrollBar
            flickableItem: genresListView
            //align: Qt.AlignTrailing
            anchors.right: parent.right
        }


    }

}

