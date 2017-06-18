import QtQuick 2.7
import BGControls 1.0
import QtQuick.Layouts 1.3
import BGStudio 1.0

BGPage {
    property var infoData
    signal afterEdited (var data)
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        BGArea {
            area: "banner"
            Layout.fillWidth: true
            height: 32
            RowLayout {
                width: parent.width
                anchors.centerIn: parent
                BGButton {
                    icon: BGIcons.icon ("back", color);
                    onClicked: stvMain.pop ()
                }
                BGText {
                    Layout.fillWidth: true
                    text: infoData.n
                }
                BGButton {
                    icon: BGIcons.icon ("yes", color);
                    onClicked: {
                        infoData.n = leName.text;
                        infoData.desc = teDesc.text;
                        //hbDataChanged ();
                        stvMain.pop ();
                        afterEdited (infoData);
                    }
                }
            }
        }
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 5
            BGLineEdit {
                id: leName
                Layout.fillWidth: true
                text: infoData.n
            }
            BGTextEdit {
                id: teDesc
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: infoData.desc
            }
        }
    }
}
