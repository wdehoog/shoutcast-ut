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
        text: Shoutcast.getMetaString(model)

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

}
