import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import BGControls 1.0
import BGStudio 1.0

ColumnLayout {
    property alias model: repeater.model
    Layout.fillWidth: true
    Layout.margins: 20
    Repeater {
        id: repeater
        model: modelData.cs
        RowLayout {
            ColumnLayout {
                spacing: 0
                BGText {
                    id: leCode
                    area: "card"
                    Layout.fillWidth: true
                    text: modelData.c
                    font.pixelSize: 18
                    font.bold: true
                    elide: Text.ElideRight
                }
                BGText {
                    area: "card"
                    Layout.fillWidth: true
                    text: modelData.desc
                    wrapMode: Text.Wrap
                    font.pixelSize: 16
                }
            }
            BGButton {
                area: "card"
                icon:BGIcons.icon ("copy", color)
                onClicked: BGClip.setText (modelData.c)
            }
        }
    }
}