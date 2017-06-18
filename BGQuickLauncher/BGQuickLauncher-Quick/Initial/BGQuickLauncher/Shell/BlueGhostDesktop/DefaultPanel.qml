import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import BGControls 1.0
import BGStudio 1.0

BGDrawer {
    id: panelRootItem
    LauncherData { id: launcherData }
    color: "#60000000"
    width: 400
    
    signal reloadedApps ()
    /*DefaultPanel {
        id: defaultPanel
    }*/
    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        ColumnLayout {
            Layout.alignment: Qt.AlignTop
            PanelToolbarIcon {
                icon: "apps"
                border.color:  BGColor.contrast(BGCtrlStyle.highlight,
                    panelRootItem.color, 0.75)
                border.width: stlSwitch.currentIndex == 0 ? 2 : 0
                onClicked: stlSwitch.currentIndex = 0
            }
            PanelToolbarIcon {
                icon: "storage"
                border.color: BGColor.contrast(BGCtrlStyle.highlight,
                    panelRootItem.color, 0.75)
                border.width: stlSwitch.currentIndex == 1 ? 2 : 0
                onClicked: stlSwitch.currentIndex = 1
            }
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
        StackLayout {
            id: stlSwitch
            Layout.fillWidth: true
            Layout.fillHeight: true
            StartMenu {}
            TaskBar {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
}