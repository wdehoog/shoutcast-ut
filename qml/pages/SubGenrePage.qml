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
    id: subGenrePage
    objectName: "SubGenrePage"

    property string genreName: ""
    property string genreId: ""

    property bool showBusy: false

    header: PageHeader {
        id: pageHeader
        title: i18n.tr("Sub-Genres for: ") + genreName
        StyleHints {
            foregroundColor: UbuntuColors.orange
            backgroundColor: UbuntuColors.porcelain
            dividerColor: UbuntuColors.slate
        }
        trailingActionBar.actions: [
            Action {
                iconName: "home"
                text: i18n.tr("Home")
                onTriggered: {
                    pageStack.pop()
                    pageStack.pop()
                }
            }
        ]

        flickable: subGenresListView
    }

    JSONListModel {
        id: genresModel
        source: Shoutcast.SecondaryGenreBase
                + "?" + Shoutcast.getParentGenrePart(genreId)
                + "&" + Shoutcast.DevKeyPart
                + "&" + Shoutcast.QueryFormat
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
            id: subGenresListView
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
                            color: UbuntuColors.orange
                            textFormat: Text.StyledText
                            font.weight: Font.Bold
                            //truncationMode: TruncationMode.Fade
                            width: parent.width - countLabel.width
                            text: name ? name : qsTr("No Genre Name")
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
                    pageStack.push(Qt.resolvedUrl("StationsPage.qml"),
                                   {genreId: model.id, genreName: model.name})
                }
            }

            model: genresModel.model

        }

        Scrollbar {
            id: scrollBar
            flickableItem: subGenresListView
            anchors.right: parent.right
        }


    }

}

