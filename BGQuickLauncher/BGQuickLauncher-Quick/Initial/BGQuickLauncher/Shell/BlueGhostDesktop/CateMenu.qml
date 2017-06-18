import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import BGControls 1.0
import BGStudio 1.0

BGArea {
    ListView {
        id: lvCate
        anchors.fill: parent
        anchors.margins: 10
        
        model: launcherData.cateModel ()
        spacing: 5
        delegate: MouseArea {
            width: lvCate.width
            height: rlCate.height
            RowLayout {
                id: rlCate
                spacing: 0
                width: parent.width
                BGText {
                    Layout.fillWidth: true
                    text: modelData
                    font.pixelSize: 22
                    font.bold: true
                }
                Image {
                    Layout.preferredWidth : 22
                    Layout.preferredHeight: 22
                    source: BGIcons.icon ("next", BGCtrlStyle.bgColor)
                }
            }
            onClicked: stvMenu.openAppsMenu (modelData);
        }
    }
    Component.onCompleted: {
        panelRootItem.reloadedApps.connect (function () {
            lvCate.model = launcherData.cateModel ();
        });
    }
}
