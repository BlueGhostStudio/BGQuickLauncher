import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import BGControls 1.0
import BGStudio 1.0

ColumnLayout {
    id: lvCodes
    property var csnsListData
    ListView {
        id: csnsList
        signal deleted (int i)
        
        onDeleted: {
            csnsListDataChanged ();
            if (i >= csnsListData.length)
                currentIndex = csnsListData.length - 1;
            else
                currentIndex = i;
            positionViewAtIndex (currentIndex, ListView.Beginning);
        }
        
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true
        model: csnsListData
        spacing: 20
        delegate: ColumnLayout {
            id: clCodeSnapshot
            Component {
                id: editCmp
                CodeSnapshotEdit {
                    onAccepted: {
                        clCodeSnapshot.csnsDataChanged ();
                    }
                }
            }
            property var csnsData: lvCodes.csnsListData[index]
            width: lvCodes.width
            spacing: 0
            Rectangle {
                Layout.fillWidth: true
                Layout.bottomMargin: 5
                height: 1
                color: BGCtrlStyle.cardtextColor
                opacity: 0.5
                antialiasing: true
            }
            RowLayout {
                Layout.fillWidth: true
                spacing: 0
                BGText {
                    area: "card"
                    Layout.fillWidth: true
                    text: csnsData.n
                    font.pixelSize: 22
                    font.bold: true
                    elide: Text.ElideRight
                }
                BGButton {
                    area: "card"
                    icon:BGIcons.icon ("copy", color)
                    onClicked: BGClip.setText (modelData.n)
                }
                BGButton {
                    area: "card"
                    icon:BGIcons.icon ("edit", color)
                    onClicked: {
                        csnsList.currentIndex = index;
                        stvMain.push (editCmp,
                        {
                            csnsData: csnsData
                        });
                    }
                }
                BGButton {
                    area: "card"
                    icon:BGIcons.icon ("delete", color)
                    onClicked: {
                        var i = index;
                        csnsListData.splice (index, 1);
                        csnsList.deleted (i);
                    }
                }
            }
            BGText {
                area: "card"
                Layout.fillWidth: true
                text: csnsData.desc
                font.pixelSize: 16
                font.italic: true
                wrapMode: Text.Wrap
                visible: text.length > 0
            }
            SubCodeList {
                model: csnsData.cs
                visible: csnsData.cs.length > 0
            }
        }
        footer: BGButton {
            Component {
                id: newCmp
                CodeSnapshotEdit {
                    onAccepted: {
                        lvCodes.csnsListData.push (data);
                        lvCodes.csnsListDataChanged ();
                        csnsList.currentIndex
                            = lvCodes.csnsListData.length - 1;
                        csnsList.positionViewAtEnd();
                    }
                }
            }
            icon: BGIcons.icon ("add", color)
            onClicked: {
                stvMain.push (newCmp, {
                    csnsData: {
                        n: "new note",
                        cs: []
                    }
                });
                /*lvCodes.csnsListData.push ({
                    n: "new note",
                    cs: []
                });
                csnsListDataChanged ();
                csnsList.currentIndex = lvCodes.csnsListData.length - 1;
                stvMain.push (editCmp,
                {
                    csnsData: lvCodes.csnsListData[csnsList.currentIndex]
                });*/
            }
        }
    }
}