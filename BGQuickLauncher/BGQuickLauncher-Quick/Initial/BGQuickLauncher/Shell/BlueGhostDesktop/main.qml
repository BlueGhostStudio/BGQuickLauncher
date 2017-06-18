import QtQuick 2.7
import QtQuick.Controls 2.0
import BGQuickLauncher 1.0
import QtQuick.Layouts 1.3
import BGControls 1.0
import QtGraphicalEffects 1.0
import "firstRun"

ApplicationWindow {
    id:appWin
    visible: true
    contentOrientation: "PortraitOrientation"
    //Screen.primaryOrientation: Qt.PortraitOrientation
    property alias instanceArea: instanceArea
    property alias favApps: favApps
    //property alias startMenu: startMenu
    //property alias startMenuButton: panel.startMenuButton
    property Launcher launcher: Launcher {
        onNewInstanceCreated: {
            item.parent = instanceArea;
            item.Layout.fillWidth = true
            item.Layout.fillHeight = true
            instanceArea.currentIndex = instanceArea.count - 1;
            if (item.setupWidget != undefined)
                item.setupWidget (widgetsArea);
        }
    }

    width: 320
    height: 544
    
    
    ShellSettings {
        id: dlgShellSettings
    }
    property BGDrawer panel: OtherPanel {
    //property BGDrawer panel: DefaultPanel {
        //id: panel
        //width: appWin.width
        height: appWin.height
    }
    WidgetsArea {
        id: widgetsArea
        width: Math.min (400, appWin.width * 0.8)
        height: appWin.height
        edge: Qt.RightEdge
    }
    
    /*TaskBar {
        width: 200
        height: parent.height
    }*/
    
    background: Image {
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: "file:" + shellPath + "Default/imgs/wp.jpg"
    
        layer.enabled: panel.visible | widgetsArea.visible
        layer.effect: FastBlur {
            radius: 32
        }
    }
    StackLayout {
        anchors.fill: parent; id: instanceArea; clip: true
        ColumnLayout {
            spacing: 0
            DateWidget {
                Layout.margins: 10
                //Layout.alignment: Qt.AlignHCenter
            }
            Item { Layout.fillHeight: true }
            FavouriteApps {
                id: favApps
                Layout.fillWidth: true
                Layout.preferredHeight: Math.min (contentHeight, 400)
                //Layout.fillHeight: true
                Layout.margins: 10
            }
        }
    
        layer.enabled: panel.visible | widgetsArea.visible
        layer.effect: FastBlur {
            radius: 32
        }
        onCurrentIndexChanged: {
            if (appWin.activeFocusItem)
                appWin.activeFocusItem.focus = false
        }
    }
    
    QuickHelp { id: quickHelp }
    
    Component.onCompleted: {
        panel.parent = appWin.overlay;
        quickHelp.start ();
    }
}
