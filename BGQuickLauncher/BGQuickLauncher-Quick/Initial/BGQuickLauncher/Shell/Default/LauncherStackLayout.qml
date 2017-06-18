import QtQuick 2.0
import QtQuick.Layouts 1.3

StackLayout {
    id: luncherStackLayout
    property alias launcher: lchApps.launcher
    LCHApps {
        id: lchApps
        anchors.fill: parent
        anchors.margins: 10
        onNewInstanceCreated: {
            instItem.parent = luncherStackLayout
            instanceNav.currentIndex = luncherStackLayout.count - 1;
        }
    }
}
