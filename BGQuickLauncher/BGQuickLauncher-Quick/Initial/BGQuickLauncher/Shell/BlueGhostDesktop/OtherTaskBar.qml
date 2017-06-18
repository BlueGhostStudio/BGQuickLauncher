import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import BGControls 1.0
import BGStudio 1.0

Flickable {
    property int currentIndex: instanceArea.currentIndex
    property int count: launcher.instanceList.length
    contentHeight: row.height
    
    clip: true
    
    ColumnLayout {
        id: row
        spacing: 5
        width: parent.width
        /*BGButton {
            Layout.fillWidth: true
            text: "Home"
            onClicked: {
                instanceArea.currentIndex = 0;
                panelRootItem.close ();
            }
        }*/
        Repeater {
            model: launcher.instanceList
            
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: rwInst.implicitHeight + 10
                color: currentIndex == index + 1
                    ? "#30ffffff" : "transparent"
                radius: 5
                RowLayout {
                    id: rwInst
                    width: parent.width - 10
                    anchors.centerIn: parent
                    Text {
                        id: txtInst
                        text: modelData.appInfo.title +
                             (modelData.title.length > 0
                             ? ("-" + modelData.title) : "")
                        color: "white"
                        font.pixelSize: 22
                        font.bold: currentIndex == index + 1
                        elide: Text.ElideLeft
                        Layout.fillWidth: true
                        opacity: currentIndex == index + 1
                            ? 1 : 0.25
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                instanceArea.currentIndex = index + 1;
                                panelRootItem.close ();
                            }
                        }
                        Behavior on opacity {
                            NumberAnimation { duration: 250 }
                        }
                    }
                    BGButton {
                        icon: BGIcons.icon ("close", color)
                        onClicked: {
                            var i = instanceArea.currentIndex;
                            var inst = launcher.instance (modelData.id);
                            inst.close ();
                            var ia = instanceArea;
                            inst.closed.connect (function () {
                                if (i >= ia.count)
                                    ia.currentIndex = ia.count - 1;
                            });
                            //startMenu.close ();
                        }
                    }
                }
            }
        }
    }
}