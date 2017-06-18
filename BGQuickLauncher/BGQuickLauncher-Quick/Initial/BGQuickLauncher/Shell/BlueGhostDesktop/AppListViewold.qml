import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

Flickable {
    property alias model: repeater.model
    contentHeight: flow.height
    clip: true
    leftMargin: 5
    topMargin: 5
    rightMargin: 5
    bottomMargin: 5
    Flow {
        id: flow
        width: parent.width
        spacing: 5
        Repeater {
            id: repeater
            AppIcon { app: modelData }
        }
    }
}
