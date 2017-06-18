import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import BGControls 1.0
import BGStudio 1.0

BGDrawer {
    id: panelRootItem
    LauncherData { id: launcherData }
    color: "#60000000"
    width: appWin.width
    //property alias widgetsArea: widgetsArea
    
    signal reloadedApps ()
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        RowLayout {
            spacing: 0
            Text {
                text: "BGQuickLauncher"
                color: "white"
                font.pixelSize: 22
            }
            Item { Layout.fillWidth: true }
            PanelToolbarIcon {
                icon: "home"
                onClicked: {
                    instanceArea.currentIndex = 0;
                    panelRootItem.close ();
                }
            }
            PanelToolbarIcon {
                icon: "settings"
                onClicked: {
                    panelRootItem.close ()
                    dlgShellSettings.open ()
                }
            }
            PanelToolbarIcon {
                icon: "refresh"
                onClicked: {
                    launcher.reloadAppList ()
                    panelRootItem.reloadedApps ()
                }
            }
        }
        Rectangle {
            height: 2
            color: "#30ffffff"
            Layout.fillWidth: true
        }
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            //StartMenu {
            OtherMenu {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 400
            }
            Rectangle {
                height: 2
                color: "#30ffffff"
                Layout.fillWidth: true
                visible: taskBar.visible
            }
            OtherTaskBar {
                id: taskBar
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 400
                visible: false
                onCountChanged: visible = count > 0
            }
        }
    }
}
