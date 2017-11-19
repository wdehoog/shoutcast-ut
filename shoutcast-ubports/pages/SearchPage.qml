import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.ListItems 1.3 as Old_ListItem

import QtQuick.XmlListModel 2.0
import QtMultimedia 5.6

import "../components"
import "../components/shoutcast.js" as Shoutcast
import "../components/Util.js" as Util

Page {
    id: searchPage
    objectName: "SearchPage"

    property int currentItem: -1
    property bool showBusy: false
    property string searchString: ""
    property int searchInType: 0

    property bool canGoNext: currentItem < (searchModel.count-1)
    property bool canGoPrevious: currentItem > 0
    property int navDirection: 0 // 0: none, -x: prev, +x: next
    property var tuneinBase: {}

    header: PageHeader {
        id: pageHeader
        title: i18n.tr("Search")
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
                    app.loadLastList(searchModel, currentItem, tuneinBase)
                    pageStack.pop()
                }
            }
        ]

        trailingActionBar.actions: [
            Action {
                iconName: "reload"
                text: i18n.tr("Reload")
                onTriggered: refresh()
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

    Item {
        id: pageLayout
        anchors {
            leftMargin: units.gu(1)
            rightMargin: units.gu(1)
            fill: parent
        }
        ListView {
            id: stationsListView
            width: parent.width - scrollBar.width
            height: childrenRect.height

            header: Column {
                spacing: units.gu(1)
                width: parent.width
                TextField {
                    id: searchField
                    width: parent.width
                    placeholderText: i18n.tr("Search for")
                    inputMethodHints: Qt.ImhNoPredictiveText
                    primaryItem: Icon {
                        height: parent.height
                        width: height
                        name: "find"
                    }
                    Binding {
                        target: searchPage
                        property: "searchString"
                        value: searchField.text.toLowerCase().trim()
                    }
                    Keys.onReturnPressed: refresh()
                }
                Row {
                    id: typeRow
                    width: parent.width
                    Label {
                        id: silabel
                        anchors.verticalCenter: parent.verticalCenter
                        text: i18n.tr("Search In: ")
                    }
                    Button {
                        id: popoverButton
                        width: parent.width - silabel.width
                        anchors.verticalCenter: parent.verticalCenter
                        color: "white"
                        text: searchInTypeLabels[searchInType]
                        onClicked: PopupUtils.open(pocSearchType, popoverButton)
                    }
                }
            }

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

            model: searchModel

        }

        Scrollbar {
            id: scrollBar
            flickableItem: stationsListView
            anchors.right: parent.right
        }
    }

    onSearchInTypeChanged: refresh()

    function refresh() {
        if(searchString.length >= 1) {
            if(searchInType === 0)
                performNowPlayingSearch(searchString)
            else
                performKeywordSearch(searchString)
        }
    }

    property string _prevSearchString: ""
    function performNowPlayingSearch(searchString) {
        if(searchString === "")
            return
        showBusy = true
        searchModel.clear()
        if(searchString === _prevSearchString)
            nowPlayingModel.refresh()
        else {
            nowPlayingModel.source = app.getSearchNowPlayingURI(searchString)
            _prevSearchString = searchString
        }
    }

    JSONListModel {
        id: nowPlayingModel
        source: ""
        query: "$..station"
        keepQuery: "$..tunein"
    }

    Connections {
        target: nowPlayingModel
        onLoaded: {
            console.log("new results: "+nowPlayingModel.model.count)
            var i
            currentItem = -1
            for(i=0;i<nowPlayingModel.model.count;i++)
                searchModel.append(nowPlayingModel.model.get(i))
            tuneinBase = {}
            if(nowPlayingModel.keepObject.length > 0) {
                var b = nowPlayingModel.keepObject[0]["base"]
                if(b)
                    tuneinBase["base"] = b
                b = nowPlayingModel.keepObject[0]["base-m3u"]
                if(b)
                    tuneinBase["base-m3u"] = b
                b = nowPlayingModel.keepObject[0]["base-xspf"]
                if(b)
                    tuneinBase["base-xspf"] = b
            }
            showBusy = false
            if(searchModel.count > 0)
                currentItem = app.findStation(app.stationId, searchModel)
        }
        onTimeout: {
            showBusy = false
            app.showErrorDialog(qsTr("SHOUTcast server did not respond"))
            console.log("SHOUTcast server did not respond")
        }
    }

    function performKeywordSearch(searchString) {
        if(searchString.length === 0)
            return
        showBusy = true
        searchModel.clear()
        app.loadKeywordSearch(searchString, function(xml) {
            //console.log("onDone: " + xml)
            if(keywordModel.xml === xml) {
                // same data so we in theory we are done
                // but the list might have contained data from 'Now Playing'
                // so we reload().
                keywordModel.reload()
                tuneinModel.reload()
            } else {
                keywordModel.xml = xml
                tuneinModel.xml = xml
            }
        }, function() {
            // timeout
            showBusy = false
            app.showErrorDialog(qsTr("SHOUTcast server did not respond"))
            console.log("SHOUTcast server did not respond")
        })
    }

    XmlListModel {
        id: keywordModel
        query: "/stationlist/station"
        XmlRole { name: "name"; query: "string(@name)" }
        XmlRole { name: "mt"; query: "string(@mt)" }
        XmlRole { name: "id"; query: "@id/number()" }
        XmlRole { name: "br"; query: "@br/number()" }
        XmlRole { name: "genre"; query: "string(@genre)" }
        XmlRole { name: "ct"; query: "string(@ct)" }
        XmlRole { name: "lc"; query: "@lc/number()" }
        XmlRole { name: "logo"; query: "string(@logo)" }
        XmlRole { name: "genre2"; query: "string(@genre2)" }
        XmlRole { name: "genre3"; query: "string(@genre3)" }
        XmlRole { name: "genre4"; query: "string(@genre4)" }
        XmlRole { name: "genre5"; query: "string(@genre5)" }
        onStatusChanged: {
            if (status !== XmlListModel.Ready)
                return
            var i
            currentItem = -1
            for(i=0;i<count;i++)
                searchModel.append(get(i))
            showBusy = false
            if(searchModel.count > 0)
                currentItem = app.findStation(app.stationId, searchModel)
        }
    }

    XmlListModel {
        id: tuneinModel
        query: "/stationlist/tunein"
        XmlRole{ name: "base"; query: "@base/string()" }
        XmlRole{ name: "base-m3u"; query: "@base-m3u/string()" }
        XmlRole{ name: "base-xspf"; query: "@base-xspf/string()" }
        onStatusChanged: {
            if (status !== XmlListModel.Ready)
                return
            tuneinBase = {}
            if(tuneinModel.count > 0) {
                var b = tuneinModel.get(0)["base"]
                if(b)
                    tuneinBase["base"] = b
                b = tuneinModel.get(0)["base-m3u"]
                if(b)
                    tuneinBase["base-m3u"] = b
                b = tuneinModel.get(0)["base-xspf"]
                if(b)
                    tuneinBase["base-xspf"] = b
            }
        }
    }

    ListModel {
        id: searchModel
    }

    Connections {
        target: app
        onStationChanged: {
            navDirection = 0
            // station has changed look for the new current one
            currentItem = app.findStation(stationInfo.id, searchModel)
        }

        onStationChangeFailed: {
            if(navDirection !== 0)
                navDirection = app.navToPrevNext(currentItem, navDirection, top500Model, tuneinBase)
        }

        onPrevious: {
            if(canGoPrevious) {
                navDirection = - 1
                var item = searchModel.get(currentItem + navDirection)
                if(item)
                    app.loadStation(item.id, Shoutcast.createInfo(item), tuneinBase)
            }
        }

        onNext: {
            if(canGoNext) {
                navDirection = 1
                var item = searchModel.get(currentItem + navDirection)
                if(item)
                     app.loadStation(item.id, Shoutcast.createInfo(item), tuneinBase)
            }
        }
    }

    property var searchInTypeLabels: [
        i18n.tr("Now Playing"),
        i18n.tr("Keywords")
    ]

    ActionList {
        id: searchInTypeActions
        Action {
            text: searchInTypeLabels[0]
            onTriggered: searchInType = 0
        }
        Action {
            text: searchInTypeLabels[1]
            onTriggered: searchInType = 1
        }
    }

    Component {
        id: pocSearchType
        ActionSelectionPopover {
            id: asp
            actions: searchInTypeActions
            delegate: Old_ListItem.Standard {
                text: action.text
                onClicked: PopupUtils.close(asp)
            }
        }
    }

}
