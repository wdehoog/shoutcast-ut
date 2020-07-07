import QtQuick 2.7
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtMultimedia 5.9

import "components/shoutcast.js" as Shoutcast
import "components/Util.js" as Util

import "components"

MainView {
    id: app
    objectName: 'mainView'
    applicationName: 'shoutcast-ubports.wdehoog'
    automaticOrientation: true

    property string defaultImageSource: "image://theme/icon-m-music"
    property string logoURL: Qt.resolvedUrl("resources/shoutcast-ubports.svg")
    property string streamMetaText1: i18n.tr("No station Info")
    property string streamMetaText2: i18n.tr("No Track Info")

    width: units.gu(45)
    height: units.gu(75)

    property int currentItem: -1
    property var tuneinBase: {}
    property bool canGoNext: currentItem < (lastListCopy.count-1)
    property bool canGoPrevious: currentItem > 0
    property int navDirection: 0 // 0: none, -x: prev, +x: next

    property alias settings: settings

    PageStack {
        id: pageStack
        anchors {
            bottom: playerArea.top
            fill: undefined
            left: parent.left
            right: parent.right
            top: parent.top
        }
        clip: true

        Component.onCompleted: {
            pageStack.push(mainPage)
        }

        Page {
            id: mainPage
            visible: false
            title: i18n.tr("SHOUTcast")

            header: PageHeader {
                id: pageHeader
                title: i18n.tr("SHOUTcast")

                trailingActionBar.actions: [
                    Action {
                        iconName: "info"
                        text: i18n.tr("About")
                        onTriggered: pageStack.push(Qt.resolvedUrl("pages/AboutPage.qml") )
                    },
                    Action {
                        iconName: "help"
                        text: i18n.tr("Help")
                        onTriggered: pageStack.push(Qt.resolvedUrl("pages/HelpPage.qml") )
                    },
                    Action {
                        iconName: "settings"
                        text: i18n.tr("Settings")
                        onTriggered: pageStack.push(Qt.resolvedUrl("pages/SettingsPage.qml") )
                    }
                ]
            }

            Column {
                spacing: units.gu(1)
                width: parent.width - 2*units.gu(1)
                x: units.gu(1)
                anchors.verticalCenter: parent.verticalCenter

                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    height: 3 * font.pixelSize
                    text: i18n.tr("Genre")
                    font.pixelSize: FontUtils.sizeToPixels("large")
                    iconSource: Qt.resolvedUrl("resources/folder.svg")
                    onClicked: pageStack.push(Qt.resolvedUrl("pages/GenrePage.qml"))
                }
                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    height: 3 * font.pixelSize
                    text: i18n.tr("Top 500")
                    font.pixelSize: FontUtils.sizeToPixels("large")
                    iconSource: Qt.resolvedUrl("resources/chevrons-up.svg")
                    onClicked: pageStack.push(Qt.resolvedUrl("pages/Top500Page.qml"))
                }
                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    height: 3 * font.pixelSize
                    text: i18n.tr("Search")
                    font.pixelSize: FontUtils.sizeToPixels("large")
                    iconSource: Qt.resolvedUrl("resources/search.svg")
                    onClicked: pageStack.push(Qt.resolvedUrl("pages/SearchPage.qml"))
                }
            }

        }

    }

    PlayerArea {
        id: playerArea
        height: visible ? childrenRect.height : 0
        visible: pageStack.currentPage.objectName !== "AboutPage"
                 && pageStack.currentPage.objectName !== "HelpPage"
    }

    Connections {
        target: playerArea
        onPause: pause()
        onPrevious: previous()
        onNext: next()
    }

    signal previous()
    signal next()

    signal audioBufferFull()
    onAudioBufferFull: play()

    Audio {
        id: audio
        //audioRole: Audio.MusicRole
        autoLoad: true
        autoPlay: false

        onPlaybackStateChanged: playerArea.audioPlaybackState = playbackState

        //onBufferProgressChanged: {
        //    if(bufferProgress == 1.0)
        //        audioBufferFull()
        //}

        onError: {
            console.log("Audio Player error:" + errorString)
            console.log("source: " + source)
            showErrorDialog(qsTr("Audio Player:") + "\n\n" + errorString)
        }

    }

    Connections {
        target: audio.metaData
        onMetaDataChanged: {
            console.log("onMetaDataChanged:" + JSON.stringify(audio.metaData))
            // seen: title, publisher, genre, audioBitRate, audioCodec
            var text = audio.metaData.title
            if(text !== undefined)
                streamMetaText1 = text
            text = audio.metaData.publisher
            if(text !== undefined)
                streamMetaText2 = text
        }
    }

    // When leaving a page it's ListModel is deleted. To still be able to next/previous
    // there is a copy of the data here.
    ListModel {
        id: lastListCopy
    }

    function loadLastList(model, item, tunein) {
        lastListCopy.clear()
        for(var i=0;i<model.count;i++)
            lastListCopy.append(model.get(i))
        currentItem = item
        tuneinBase = tunein
    }

    onPrevious: {
        console.log("onPrevious canGoPrevious=" + canGoPrevious + ", navDirection=" + navDirection)
        if(canGoPrevious) {
            navDirection = - 1
            var item = lastListCopy.get(currentItem + navDirection)
            if(item)
                app.loadStation(item.id, Shoutcast.createInfo(item), tuneinBase)
        }
    }

    onNext: {
        console.log("onNext canGoNext=" + canGoNext + ", navDirection=" + navDirection)
        if(canGoNext) {
            navDirection = 1
            var item = lastListCopy.get(currentItem + navDirection)
            if(item)
                 app.loadStation(item.id, Shoutcast.createInfo(item), tuneinBase)
        }
    }

    onStationChangeFailed: {
        if(navDirection !== 0)
            navDirection = app.navToPrevNext(currentItem, navDirection, lastListCopy, tuneinBase)
    }

    function play() {
        console.log("play() audio.source:" + audio.source)
        audio.play()
    }

    function pause() {
        console.log("pause() audio.source:" + audio.source)
        if(audio.playbackState === Audio.PlayingState)
            audio.pause()
        else
            play()
    }

    property var currentStationInfo

    onStationChanged: {

        // navigation done on MainPage
        if(navDirection != 0) {
            currentItem += navDirection
            navDirection = 0
        }

        currentStationInfo = stationInfo
        console.log("set stream:" + stationInfo.stream)
        //app.stationId = stationInfo.id

        streamMetaText1 = stationInfo.name + " - " + stationInfo.lc + " " + Shoutcast.getAudioType(stationInfo.mt) + " " + stationInfo.br
        streamMetaText2 = (stationInfo.genre ? (stationInfo.genre + " - ") : "") + stationInfo.ct
        logoURL = stationInfo.logo ? stationInfo.logo : ""

        audio.source = stationInfo.stream
        play()

        var histObj = createHistoryObject(stationInfo.name, stationInfo.logo, Shoutcast.getMetaString(stationInfo))
        notifyHistory(histObj)
    }

    signal stationChanged(var stationInfo)
    signal stationChangeFailed(var stationInfo)

    function loadStation(stationId, info, tuneinBase) {
        var m3uBase = tuneinBase["base-m3u"]

        if(!m3uBase) {
            showErrorDialog(qsTr("Don't know how to retrieve playlist."))
            console.log("Don't know how to retrieve playlist.: \n" + JSON.stringify(tuneinBase))
        }

        var xhr = new XMLHttpRequest
        var playlistUri = Shoutcast.TuneInBase
                + m3uBase
                + "?" + Shoutcast.getStationPart(stationId)
        xhr.open("GET", playlistUri)
        xhr.onreadystatechange = function() {
            if(xhr.readyState === XMLHttpRequest.DONE) {
                var playlist = xhr.responseText;
                console.log("Playlis for stream: \n" + playlist)
                var streamURL
                streamURL = Shoutcast.extractURLFromM3U(playlist)
                console.log("URL: \n" + streamURL)
                if(streamURL.length > 0) {
                    info.stream = streamURL
                    stationChanged(info)
                } else {
                    showErrorDialog(qsTr("Failed to retrieve stream URL."))
                    console.log("Error could not find stream URL: \n" + playlistUri + "\n" + playlist + "\n")
                    stationChangeFailed(info)
                }
            }
        }
        xhr.send();
    }

    function loadKeywordSearch(keywordQuery, onDone, onTimeout) {
        var xhr = new XMLHttpRequest
        var uri = Shoutcast.KeywordSearchBase
            + "?" + Shoutcast.DevKeyPart
            + "&" + Shoutcast.getLimitPart(settings.max_number_of_results)
        if(settings.mime_type_filter === 1)
            uri += "&" + Shoutcast.getAudioTypeFilterPart("audio/mpeg")
        else if(settings.mime_type_filter === 2)
            uri += "&" + Shoutcast.getAudioTypeFilterPart("audio/aacp")
        uri += "&" + Shoutcast.getSearchPart(keywordQuery)
        //console.log("loadKeywordSearch: " + uri)
        xhr.open("GET", uri)
        xhr.onreadystatechange = function() {
            if(xhr.readyState === XMLHttpRequest.DONE) {
                timer.destroy()
                onDone(xhr.responseText)
            }
        }
        var timer = createTimer(app, settings.server_timeout*1000)
        timer.triggered.connect(function() {
            if(xhr.readyState === XMLHttpRequest.DONE)
                return
            xhr.abort()
            onTimeout()
            timer.destroy()
        });
        xhr.send();
    }

    function loadTop500(onDone, onTimeout) {
        var xhr = new XMLHttpRequest
        var uri = Shoutcast.Top500Base
                + "?" + Shoutcast.DevKeyPart
                + "&" + Shoutcast.getLimitPart(settings.max_number_of_results)
                + "&" + Shoutcast.QueryFormat
        if(settings.mime_type_filter === 1)
            uri += "&" + Shoutcast.getAudioTypeFilterPart("audio/mpeg")
        else if(settings.mime_type_filter === 2)
            uri += "&" + Shoutcast.getAudioTypeFilterPart("audio/aacp")
        xhr.open("GET", uri)
        xhr.onreadystatechange = function() {
            if(xhr.readyState === XMLHttpRequest.DONE) {
                timer.destroy()
                onDone(xhr.responseText)
            }
        }
        var timer = createTimer(app, settings.server_timeout*1000)
        timer.triggered.connect(function() {
            if(xhr.readyState === XMLHttpRequest.DONE)
                return
            xhr.abort()
            onTimeout()
            timer.destroy()
        });
        xhr.send();
    }

    function createTimer(root, interval) {
        return Qt.createQmlObject("import QtQuick 2.0; Timer {interval: " + interval + "; repeat: false; running: true;}", root, "TimeoutTimer");
    }

    function getSearchNowPlayingURI(nowPlayingQuery) {
        if(nowPlayingQuery.length === 0)
            return ""
        var uri = Shoutcast.NowPlayingSearchBase
                  + "?" + Shoutcast.DevKeyPart
                  + "&" + Shoutcast.QueryFormat
                  + "&" + Shoutcast.getLimitPart(settings.max_number_of_results)
        if(settings.mime_type_filter === 1)
            uri += "&" + Shoutcast.getAudioTypeFilterPart("audio/mpeg")
        else if(settings.mime_type_filter === 2)
            uri += "&" + Shoutcast.getAudioTypeFilterPart("audio/aacp")
        uri += "&" + Shoutcast.getPlayingPart(nowPlayingQuery)
        return uri
    }

    function getStationByGenreURI(genreId) {
      var uri = Shoutcast.StationSearchBase
                    + "?" + Shoutcast.getGenrePart(genreId)
                    + "&" + Shoutcast.DevKeyPart
                    + "&" + Shoutcast.getLimitPart(settings.max_number_of_results)
                    + "&" + Shoutcast.QueryFormat
        if(settings.mime_type_filter === 1)
            uri += "&" + Shoutcast.getAudioTypeFilterPart("audio/mpeg")
        else if(settings.mime_type_filter === 2)
            uri += "&" + Shoutcast.getAudioTypeFilterPart("audio/aacp")
        return uri
    }

    function findStation(id, model) {
        for(var i=0;i<model.count;i++) {
            if(model.get(i).id === id)
                return i
        }
        return -1
    }

    // when loading prev/next failed try the following one in the same direction
    function navToPrevNext(currentItem, navDirection, model, tuneinBase) {
        var item
        if(navDirection === -1 || navDirection === 1) {
            if(navDirection > 0 // next?
               && (currentItem + navDirection) < (model.count-1))
                navDirection++
            else if(navDirection < 0 // prev?
                      && (currentItem - navDirection) > 0)
                navDirection--
            else // reached the end
                navDirection = 0

            if(navDirection !== 0) {
                item = model.get(currentItem + navDirection)
                if(item)
                    app.loadStation(item.id, Shoutcast.createInfo(item), tuneinBase)
            }
        }
        return navDirection
    }

    Component {
        id: dialog
        Dialog {
            id: dialogue
            property string messageTitle: "SHOUTcast"
            property string messageText: "no text"
            title: messageTitle
            text: messageText
            Button {
                text: i18n.tr("Ok")
                onClicked: PopupUtils.close(dialogue)
            }
        }
    }

    function showMessageDialog(title, text) {
        PopupUtils.open(dialog, app, {messageTitle: title, messageText: text})
    }

    function showErrorDialog(text) {
        PopupUtils.open(dialog, app, {messageTitle: i18n.tr("Error"), messageText: text})
    }



    /**
     * History
     */

    property var history: []

    function createHistoryObject(name, logo, meta) {
        var histObj = {
            name: name,
            logo: logo,
            meta: meta}
        return histObj
    }

    function compareHistoryObjects(obj0, obj1) {
        var res = obj0.name.localeCompare(obj1.name)
        if(res != 0)
            return res
        res = obj0.logo.localeCompare(obj1.logo)
        if(res != 0)
            return res
        return obj0.meta.localeCompare(obj1.meta)
    }

    function notifyHistory(histObj) {
        //console.log(JSON.stringify(histObj, null, 2))
        var removedIndex = -1
        if(history.length === 0) {
            history.unshift(histObj)
        } else if(compareHistoryObjects(history[0], histObj) == 0) {
            // already at the top
            return
        } else {
            // add to the top
            history.unshift(histObj)
            // remove if already present
            for(var i=1;i<history.length;i++)
                if(compareHistoryObjects(history[i], histObj) == 0) {
                    history.splice(i, 1)
                    removedIndex = i - 1 // -1 since the model does not have the new one yet
                    break
                }
        }
        if(history.length > settings.historyMaxSize) { // make configurable
            history.pop()
        }
        settings.history = history
        //console.log(JSON.stringify(settings.history, null, 2))
    }

    function removeHistory(index) {
        history.splice(index, 1)
        settings.history = history
    }

    function clearHistory() {
        history = []
        settings.history = history
    }

    function removeSearchHistory(index) {
        var sh = settings.searchHistory
        sh.splice(index, 1)
        settings.searchHistory = sh
    }

    Component.onCompleted: {
        history = settings.history
    }

    Settings {
        id: settings

        // number of results to as shoutcast server per request
        property int max_number_of_results : 500

        // time to wait for shoutcast server to respond
        property int server_timeout : 10

        // 0: no filter, 1: only audio/mpeg, 2: only audio/aacp
        property int mime_type_filter: 0

        // show station logos in the station lists (or not)
        // it looks nice but on my Moto G 2nd it makes the app crash
        // on large lists like the Top500
        property bool show_station_logo_in_lists: true

        // played stations
        property var history: []
        property int historyMaxSize: 50

        // search history
        property var searchHistory: []
        property int searchHistoryMaxSize: 50
    }

}

