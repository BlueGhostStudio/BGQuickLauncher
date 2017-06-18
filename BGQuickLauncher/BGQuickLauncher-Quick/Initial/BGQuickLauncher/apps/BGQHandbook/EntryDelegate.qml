import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import BGControls 1.0
import BGStudio 1.0

BGArea {
    area: "card"
    property int desMaxHeight:-1
    
    property var indexData: entryListData[index]
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        RowLayout {
            BGText {
                //Layout.preferredWidth: 128
                Layout.fillWidth: true
                text: indexData.n
                font.pixelSize: 32
                font.bold: true
                wrapMode: Text.Wrap
            }
            BGButton {
                icon: BGIcons.icon ("edit", color)
                onClicked: {
                    stvMain.push (editCmp,
                    {
                        infoData: entryListData[index]
                    });
                }
            }
            BGButton {
                icon: BGIcons.icon ("delete", color)
                onClicked: {
                    var i = index;
                    entryListData.splice (i, 1);
                    swvEntry.deleted (i);
                }
            }
        }
        BGText {
            Layout.fillWidth: true
            Layout.maximumHeight: desMaxHeight
            text: indexData.desc
            font.pixelSize: 22
            wrapMode: Text.Wrap
            elide: Text.ElideRight
            visible: text.length > 0
        }
        
        Component {
            id: editCmp
            InfoEditPage {
                onAfterEdited: indexDataChanged ()
            }
        }
        CodeSnapshotList {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.topMargin: 20
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            csnsListData: cateData.hb[index].csns
        }
    }
}