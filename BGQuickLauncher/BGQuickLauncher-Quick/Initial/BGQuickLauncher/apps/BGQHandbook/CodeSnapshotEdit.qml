import QtQuick 2.7
import BGControls 1.0
import QtQuick.Layouts 1.3
import BGStudio 1.0

BGPage {
    id: codeSnapshotEditPage
    property var csnsData
    signal accepted (var data)
    
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
                    onClicked: stvMain.pop ();
                }
                BGText {
                    Layout.fillWidth: true
                    text: csnsData.n
                }
                BGButton {
                    icon: BGIcons.icon ("yes", color);
                    onClicked: {
                        csnsData.n = leName.text
                        csnsData.desc = teDesc.text
                        csnsData.cs = subCodeEdit.subCodeData;
                        stvMain.pop ();
                        codeSnapshotEditPage.accepted (csnsData);
                        /*var index = csnsList.currentIndex;
                        csnsListDataChanged ();
                        csnsList.currentIndex = index;
                        csnsList.positionViewAtIndex (csnsList.currentIndex,
                            ListView.Beginning);
                        
                        stvMain.pop ();*/
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
                text: csnsData.n
            }
            BGTextEdit {
                id: teDesc
                Layout.fillWidth: true
                text: csnsData.desc
            }
            Rectangle {
                Layout.fillWidth: true
                height: 2
                color: BGCtrlStyle.textColor
            }
            SubCodeEdit {
                id: subCodeEdit
                Layout.fillWidth:true
                Layout.fillHeight: true
            }
        }
    }
}