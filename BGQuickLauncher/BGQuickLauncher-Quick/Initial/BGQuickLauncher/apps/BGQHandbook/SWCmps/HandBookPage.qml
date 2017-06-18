import QtQuick 2.7
import BGControls 1.0
import QtQuick.Layouts 1.3
import BGStudio 1.0

ListView {
    id: lvHandBook
    Component {
        id: codeSnapshotListCmp
        CodeSnapshotList {}
    }
    property string title
    clip: true
    spacing: 5
    header: BGArea {
        area: "banner"
        width: lvHandBook.width
        height: rlHeader.height
        RowLayout {
            id: rlHeader
            BGButton {
                icon: BGIcons.icon ("back",color)
                onClicked: stvShellWiget.pop ()
            }
            BGText {
                text: title
                font.bold: true
            }
        }
        z: 10
    }
    headerPositioning: ListView.OverlayHeader
    delegate: ColumnLayout {
        width: lvHandBook.width
        spacing: 0
        BGText {
            Layout.fillWidth: true
            color: "white"
            text: modelData.n
            font.pixelSize: 22
            wrapMode: Text.Wrap
            MouseArea {
                anchors.fill: parent
                onClicked: stvShellWiget.push (codeSnapshotListCmp, {
                    model: modelData.csns,
                    title: modelData.n
                });
            }
        }
        BGText {
            Layout.fillWidth: true
            color: "white"
            text: modelData.desc
            font.pixelSize: 10
            wrapMode: Text.Wrap
        }
    }
}
