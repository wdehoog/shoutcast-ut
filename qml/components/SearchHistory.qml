/*
  Copyright (C) 2020 Willem-Jan de Hoog
*/
import QtQuick 2.4
import Ubuntu.Components 1.3
import QtQuick.XmlListModel 2.0
import QtMultimedia 5.6

import "../components"
import "../components/shoutcast.js" as Shoutcast
import "../components/Util.js" as Util

Page {
    id: searchHistory
    objectName: "SearchHistory"

    signal accepted()
    property var selectedItem: undefined

    header: PageHeader {
        id: pageHeader
        title: i18n.tr("Search History")
        flickable: listView
    }

    ListModel {
        id: items
    }

    function loadListModel() {
        var sh = app.settings.searchHistory
        items.clear()
        for(var i=0;i<sh.length;i++) {
            items.append({text: sh[i]})
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
            width: parent.width 
            Label {
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                wrapMode: Label.Wrap
                text: model.text
            }
            onClicked: {
                selectedItem = model.text
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

