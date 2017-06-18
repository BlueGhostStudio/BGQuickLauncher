import QtQuick 2.7
import BGStudio 1.0

Rectangle {
    id: iconRootItem
    property string icon
    color: "#00000000"
    width: 32
    height: 32
    signal clicked ()
    opacity: mouseArea.pressed ? 0.5 : 1
    Image {
        anchors.fill: parent
        //anchors.margins: 8
        source: BGIcons.icon (icon, panelRootItem.color)
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: iconRootItem.clicked ()
    }
}
