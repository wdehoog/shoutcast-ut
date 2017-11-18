import QtQuick 2.4
import Ubuntu.Components 1.3

import "shoutcast.js" as Shoutcast

Column {
    id: stationListItemViewColumn
    width: parent.width
    anchors.verticalCenter: parent.verticalCenter

    // name
    // lc, genre, mt/br
    // ct

    Label {
        id: nameLabel
        width: parent.width
        color:  UbuntuColors.orange
        textFormat: Text.StyledText
        font.weight: currentItem === index ? Font.Bold : Font.Normal
        //truncationMode: TruncationMode.Fade
        text: name
    }

    Label {
        id: metaLabel
        width: parent.width
        color: UbuntuColors.coolGrey
        font.weight: currentItem === index ? Font.Bold : Font.Normal
        //font.pixelSize: Theme.fontSizeExtraSmall
        //truncationMode: TruncationMode.Fade
        text: getMetaString(model)

    }

    Label {
        id: trackLabel
        width: parent.width
        color: UbuntuColors.darkGrey
        font.weight: currentItem === index ? Font.Bold : Font.Normal
        //font.pixelSize: Theme.fontSizeExtraSmall
        textFormat: Text.StyledText
        //truncationMode: TruncationMode.Fade
        text: ct ? ct : qsTr("no track info")
    }

    function getMetaString(model) {
        var mstr = ""
        if(model.lc)
            mstr += lc;
        var gstr = genreString(model)
        if(gstr.length > 0) {
            if(mstr.length > 0)
                mstr += ", "
            mstr += gstr
        }
        if(model.mt) {
            if(mstr.length > 0)
                mstr += ", "
            mstr += Shoutcast.getAudioType(model.mt)
        }
        if(model.br) {
            if(mstr.length > 0)
                mstr += "/"
            mstr += model.br
        }
        return mstr
    }

    function genreString(model) {
        //console.log(model.id + ": l=" + model.ct.length + ", text=" + model.ct)
        var str = ""
        if(model.genre)
            str += genre
        if(model.genre2)
            str += ", " + genre2
        if(model.genre3)
            str += ", " + genre3
        if(model.genre4)
            str += ", " + genre4
        if(model.genre5)
            str += ", " + genre5
        return str
    }
}
