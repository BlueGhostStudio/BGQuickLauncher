import QtQuick 2.7
import QtQuick.Layouts 1.3
import BGControls 1.0
import BGQuickLauncher 1.0

ListView {
    id: mediaList
    anchors.fill: parent
    clip: true
    //model: mediaLibrary.medias
    delegate: BGCardNew {
        area: ListView.isCurrentItem ? "selected" : "card"
        shdRadius: 2
        padding: 10
        radius: 0
        width: mediaList.width
        z: 0
        MouseArea {
            width: parent.width
            implicitHeight: rlMedia.implicitHeight + 10
            RowLayout {
                id: rlMedia
                width: parent.width
                anchors.centerIn: parent
                BGText {
                    Layout.fillWidth: true
                    text: modelData.vaild
                        ? modelData.TIT2
                        : /[^\/]*$/.exec (modelData.file)[0]
                    elide: Text.ElideRight
                    font.pixelSize: 16
                    font.bold: true
                }
                BGText {
                    Layout.preferredWidth: 80
                    visible: modelData.vaild
                    text: modelData.TPE1 ? modelData.TPE1 : ""
                    elide: Text.ElideRight
                    font.pixelSize: 16
                    font.bold: true
                }
                BGText {
                    Layout.preferredWidth: 150
                    visible: modelData.vaild
                    text: modelData.TALB ? modelData.TALB : ""
                    elide: Text.ElideRight
                    font.pixelSize: 16
                    font.bold: true
                }
            }
            onClicked: mediaList.currentIndex = index
        }
    }
}
