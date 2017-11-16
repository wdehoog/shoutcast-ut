/*
  Copyright (C) 207 Willem-Jan de Hoog
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

    property bool showBusy: true

    header: PageHeader {
        id: pageHeader
        title: i18n.tr("Genres")
        StyleHints {
            foregroundColor: UbuntuColors.orange
            backgroundColor: UbuntuColors.porcelain
            dividerColor: UbuntuColors.slate
        }

        leadingActionBar.actions: [
            Action {
                iconName: "back"
                text: i18n.tr("Back")
                onTriggered: pageStack.pop();
            }
        ]
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
            //app.showErrorDialog(qsTr("SHOUTcast server did not respond"))
            console.log("SHOUTcast server did not respond")
        }
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
                //height: stationListItemView.height
                //x: Theme.paddingMedium
                //contentHeight: childrenRect.height

                Column {
                    width: parent.width

                    Item {
                        width: parent.width
                        //height: nameLabel.height

                        Label {
                            id: nameLabel
                            color: UbuntuColors.orange
                            textFormat: Text.StyledText
                            //truncationMode: TruncationMode.Fade
                            width: parent.width - countLabel.width
                            text: name ? name : qsTr("No Station Name")
                        }
                        Label {
                            id: countLabel
                            anchors.right: parent.right
                            color: UbuntuColors.coolGrey
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
            flickableItem: stationsListView
            align: Qt.AlignTrailing
        }


    }

}

