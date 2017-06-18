import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import BGControls 1.0
import BGStudio 1.0

BGPage {
    property var cateData
    property var entryListData: cateData.hb
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        BGArea {
            area: "banner"
            Layout.fillWidth: true
            height: clHeader.height + 10
            RowLayout {
                id: clHeader
                width: parent.width
                anchors.centerIn: parent
                BGButton {
                    iconSize: 32
                    icon: BGIcons.icon ("back", color);
                    onClicked: stvMain.pop ()
                }
                ColumnLayout {
                    spacing: 0
                    BGText {
                        Layout.fillWidth: true
                        text: cateData.n
                        font.pixelSize: 22
                        font.bold: true
                    }
                    BGText {
                        Layout.fillWidth: true
                        text: cateData.desc
                        font.pixelSize: 16
                    }
                }
            }
        }
        SwipeView {
            id: swvEntry
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            currentIndex: lvEntryIndex.currentIndex
            signal deleted (int i)
            onDeleted: {
                entryListDataChanged ();
                if (i >= entryListData.length)
                    currentIndex = entryListData.length - 1;
                else
                    currentIndex = i;
            }
            Repeater {
                model: entryListData
                EntryDelegate {}
            }
        }
        RowLayout {
            ListView {
                id: lvEntryIndex
                currentIndex: swvEntry.currentIndex
                Layout.fillWidth: true
                height: 32
                model: entryListData
                orientation: ListView.Horizontal
                spacing: 1
                delegate: BGArea {
                    area: "card"
                    height: 32
                    width: txtIndex.width + 10
                    opacity: ListView.isCurrentItem ? 1 : 0.25
                    BGText {
                        id: txtIndex
                        anchors.centerIn: parent
                        text: modelData.n
                        font.bold: true
                        font.pixelSize: 22
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: swvEntry.currentIndex = index
                    }
                }
            }
            BGButton {
                Component {
                    id: newCmp
                    InfoEditPage {
                        onAfterEdited: {
                            entryListData.push (data);
                            entryListDataChanged ();
                            swvEntry.currentIndex = entryListData.length - 1
                        }
                    }
                }
                iconSize: 22
                icon: BGIcons.icon ("add", color)
                onClicked: {
                    stvMain.push (newCmp, {
                        infoData: {
                            n: "new handbook",
                            csns: []
                        }
                    });
                }
            }
        }
    }
}
