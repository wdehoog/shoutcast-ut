import QtQuick 2.4
import Lomiri.Components 1.3

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
        color: app.primaryColor
        textFormat: Text.StyledText
        font.weight: currentItem === index ? Font.Bold : Font.Normal
        text: name
    }

    Label {
        id: metaLabel
        width: parent.width
        color: app.secondaryColor
        font.weight: currentItem === index ? Font.Bold : Font.Normal
        text: Shoutcast.getMetaString(model)

    }

    Label {
        id: trackLabel
        width: parent.width
        color: app.tertiaryColor
        font.weight: currentItem === index ? Font.Bold : Font.Normal
        textFormat: Text.StyledText
        text: ct ? ct : qsTr("no track info")
    }

}
