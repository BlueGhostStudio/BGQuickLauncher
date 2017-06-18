import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import BGControls 1.0
import BGStudio 1.0
import "Data.js" as Data

BGPage {
    header: BGArea {
        area: "banner"
        height: 48
        RowLayout {
            width: parent.width
            anchors.centerIn: parent
            BGText {
                text: "Categories"
                font.pixelSize: 32
                font.bold: true
            }
            Item { Layout.fillWidth: true }
            BGButton {
                icon: BGIcons.icon ("save", color)
                onClicked: Data.save ()
            }
        }
    }
    Component {
        id: handBookCmp
        HandBookPage {}
    }
    GridView {
        id: gvCate
        clip: true
        anchors.fill: parent
        model: hbData
        cellWidth: 160
        cellHeight: 160
        delegate: CateIndexDelegate {
            indexData: hbData[index]
            width: gvCate.cellWidth
            height: gvCate.cellHeight
        }
    }
    footer: RowLayout {
        Item { Layout.fillWidth: true }
        BGButton {
            Component {
                id: newCmp
                InfoEditPage {
                    onAfterEdited: {
                        hbData.push (data);
                        hbDataChanged ();
                        gvCate.currentIndex = hbData.length - 1
                    }
                }
            }
            
            padding: 10
            iconSize: 32
            icon: BGIcons.icon ("add", color)
            onClicked: {
                stvMain.push (newCmp, {
                    infoData: {
                        n: "--",
                        hb: []
                    }
                });
            }
        }
    }
}
