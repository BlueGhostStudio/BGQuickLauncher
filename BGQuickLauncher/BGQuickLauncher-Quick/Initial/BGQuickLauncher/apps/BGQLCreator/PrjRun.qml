import QtQuick 2.7
import QtQuick.Layouts 1.3
import BGControls 1.0
import BGStudio 1.0
import BGQuickLauncher 1.0

ColumnLayout {
    property Item runningItem: null
    
    spacing: 0
    
    function stop () {
        if (runningItem != null) {
            runningItem.destroy ();
            runningItem = null;
            creatorRootItem.Launcher.launcher.clearComponentCache ();
        }
    }
    function run (restart) {
        if (runningItem == null || restart) {
            stop ();
            BGLauncherLog.clear ();
            var cmp = Qt.createComponent (
                BGFile.urlToPath (prjFiles.rootDir) + "/main.qml");
            if (cmp.status === Component.Error) {
                console.warn (cmp.errorString ());
                creatorRootItem.Launcher.launcher.clearComponentCache ();
            } else {
                runningItem = cmp.createObject ();
                runningItem.parent = runArea;
                runningItem.anchors.fill = runArea;
            }
        }
    }
    
    BGArea {
        area: "banner"
        Layout.fillWidth: true
        height: 42
        NavBarDeco { anchors.fill: parent }
        BGText {
            anchors.centerIn: parent
            text: "Run"
            font.pixelSize: 22
            font.bold: true
        }
    }
    Item {
        id: runArea
        Layout.fillWidth: true
        Layout.fillHeight: true
    }
}
