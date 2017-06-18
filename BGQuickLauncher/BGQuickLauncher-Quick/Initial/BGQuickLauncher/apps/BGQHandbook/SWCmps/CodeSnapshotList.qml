import QtQuick 2.7
import BGControls 1.0
import QtQuick.Layouts 1.3
import BGStudio 1.0

ListView {
    id: lvCodeSnapshot
    property string title
    spacing: 5
    clip: true
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
            opacity: ma1.pressed ? 0.5 : 1
            MouseArea {
                id: ma1
                anchors.fill: parent
                onClicked: BGClip.setText (modelData.n)
            }
        }
        BGText {
            Layout.fillWidth: true
            color: "white"
            text: modelData.desc
            font.pixelSize: 10
            wrapMode: Text.Wrap
        }
        ColumnLayout {
            spacing: 0
            Layout.leftMargin: 20
            Layout.topMargin: 5
            Layout.bottomMargin: 5
            Repeater {
                model: modelData.cs
                ColumnLayout {
                    spacing: 0
                    BGText {
                        Layout.fillWidth: true
                        color: "white"
                        text: modelData.c
                        font.pixelSize: 14
                        wrapMode: Text.Wrap
                        opacity: ma2.pressed ? 0.5 : 1
                        MouseArea {
                            id: ma2
                            anchors.fill: parent
                            onClicked: BGClip.setText (modelData.c)
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
        }
    }
}
