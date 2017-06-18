import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import BGControls 1.0
import BGStudio 1.0

BGDrawer {
    color: "#60000000"
    function addWidget(item) {
        item.parent = clWidgets;
        item.Layout.fillWidth = true;
    }
    Flickable {
        id: flickable
        anchors.fill: parent
        anchors.margins: 10
        property int count: clWidgets.children.length
        contentHeight: clWidgets.height
        ColumnLayout {
            id: clWidgets
            width: parent.width
            height: Math.max (implicitHeight, flickable.height)
        }
    }
}