/*
  Copyright (C) 2020 Willem-Jan de Hoog
*/
import QtQuick 2.4
import Lomiri.Components 1.3
import QtQuick.XmlListModel 2.0
import QtMultimedia 5.6

import "../components"
import "../components/shoutcast.js" as Shoutcast
import "../components/Util.js" as Util

Page {
    id: playHistory
    objectName: "PlayHistory"

    signal accepted()
    property var selectedIndex: -1
    property var selectedName: ""

    header: PageHeader {
        id: pageHeader
        title: i18n.tr("Play History")
        flickable: listView
        trailingActionBar.actions: [
            Action {
                iconName: "delete"
                text: i18n.tr("Clear")
                onTriggered: {
                    app.showConfirmDialog(
                        i18n.tr("Confirm"), 
                        i18n.tr("Do you really want to clear the Play History?"),
                        function() {
                            app.clearHistory()
                            loadListModel()
                        }
                    )
                }
            }
        ]
    }

    ListModel {
        id: items
    }

    function loadListModel() {
        var sh = app.history
        items.clear()
        for(var i=0;i<sh.length;i++) {
            items.append(sh[i])
        }
    }

    ListView {
        id: listView
        width: parent.width - scrollBar.width
        height: parent.height

        anchors {
            horizontalCenter: parent.horizontalCenter
            topMargin: units.gu(2)
        }

        delegate: ListItem {
            id: delegate
            height: units.gu(7)
            width: parent.width 
            Row {
                height: parent.height
                width: parent.width 
                Icon {
                    id: image
                    asynchronous: true
                    height: parent.height
                    width: height
                    source: logo ? logo : ""
                }

                // spacer
                Rectangle {
                    width: units.gu(1)
                    height: parent.height
                    opacity: 0
                }

                Column {
                    //height: parent.height
                    width: parent.width - units.gu(8)
                    anchors.verticalCenter: parent.verticalCenter

                    Label { 
                        width: parent.width
                        color: app.primaryColor
                        wrapMode: Label.Wrap
                        text: name
                    }
                    Label { 
                        width: parent.width
                        color: app.secondaryColor
                        wrapMode: Label.Wrap
                        text: meta
                    }
                }
            }

            leadingActions: ListItemActions {
                actions: [
                    Action {
                        id: swipeDeleteAction
                        objectName: "swipeDeleteAction"
                        text: i18n.tr("Delete")
                        iconName: "delete"
                        onTriggered: {
                            var i = index
                            items.remove(i)
                            app.removeHistory(i)
                        }
                    }
                ]
            }

            onClicked: {
                selectedIndex = index
                selectedName = model.name
                pageStack.pop()
                accepted()
            }
        }

        model: items

    }

    Scrollbar {
        id: scrollBar
        flickableItem: listView
        anchors.right: parent.right
    }

    Component.onCompleted: {
        loadListModel()
    }
}

