import QtQuick 2.7
import BGControls 1.0
import BGStudio 1.0

ListView {
    id: lvCate
    property var _data: hbData
    clip: true
    spacing: 5
    Component {
        id: handBookPageCmp
        HandBookPage {}
    }
    model: _data
    delegate: BGText {
        width: lvCate.width
        text: modelData.n
        color: "white"
        font.pixelSize: 22
        MouseArea {
            anchors.fill: parent
            onClicked: stvShellWiget.push (handBookPageCmp, {
                model: modelData.hb,
                title: modelData.n
            });
        }
    }
    footer: BGButton {
        icon: BGIcons.icon ("refresh",color)
        onClicked: _dataChanged ();
    }
}
