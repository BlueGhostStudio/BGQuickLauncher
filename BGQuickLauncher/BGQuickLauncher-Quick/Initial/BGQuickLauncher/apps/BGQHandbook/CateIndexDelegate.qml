import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import BGControls 1.0
import BGStudio 1.0

BGCardNew {
    property int desMaxHeight:-1
    property int titleSize: 22
    
    property var indexData
    
    default property alias contentItem: contentWrap.data
    
    Component {
        id: editCmp
        InfoEditPage {
            onAfterEdited: {
                var index = gvCate.currentIndex;
                hbDataChanged ();
                gvCate.currentIndex = index;
                gvCate.positionViewAtIndex (gvCate.currentIndex,
                        ListView.Beginning);
            }
        }
    }
    ColumnLayout {
        spacing: 0
        BGText {
            //Layout.preferredWidth: 128
            Layout.fillWidth: true
            text: indexData.n
            font.pixelSize: titleSize
            font.bold: true
            wrapMode: Text.Wrap
        }
        BGText {
            Layout.fillWidth: true
            Layout.maximumHeight: desMaxHeight
            text: indexData.desc
            font.pixelSize: titleSize * 0.75
            wrapMode: Text.Wrap
            elide: Text.ElideRight
        }
        Item {
            id: contentWrap
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
        RowLayout {
            spacing: 0
            Item { Layout.fillWidth: true }
            BGButton {
                icon: BGIcons.icon ("next", color)
                onClicked: {
                    stvMain.push (handBookCmp,
                    {
                        cateData: hbData[index]
                    });
                }
            }
            BGButton {
                icon: BGIcons.icon ("edit", color)
                onClicked: {
                    stvMain.push (editCmp,
                    {
                        infoData: hbData[index]
                    });
                }
            }
            BGButton {
                icon: BGIcons.icon ("delete", color)
                onClicked: {
                    hbData.splice (index, 1);
                    hbDataChanged ();
                }
            }
        }
    }
}