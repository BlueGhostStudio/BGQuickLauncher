import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import BGControls 1.0
import BGStudio 1.0

BGPage {
    property string category
    
    header: BGArea {
        area: "banner"
        height: rlHeader.implicitHeight
        RowLayout {
            id: rlHeader
            anchors.fill: parent
            BGButton {
                icon: BGIcons.icon("back", BGCtrlStyle.bannerbtnColor)//"arrowBack.png"
                onClicked: stvMenu.backToCateMenu ()
            }
            BGText {
                text: category
                Layout.fillWidth: true
                font.pixelSize: 22
                font.bold: true
            }
        }
    }
    
    Flickable {
        anchors.fill: parent
        anchors.margins: 10
        contentHeight: flApps.height
        Flow {
            id: flApps
            width: parent.width
            spacing: 5
            Repeater {
                id: repeater
                model: launcherData.appModel (category)
                AppIcon {
                    app: modelData
                    onClicked: panelRootItem.close ()
                }
            }
        }
    }
    
    Component.onCompleted: {
        panelRootItem.reloadedApps.connect (function () {
            if (category)
                repeater.model = launcherData.appModel (category);
        });
    }
}
