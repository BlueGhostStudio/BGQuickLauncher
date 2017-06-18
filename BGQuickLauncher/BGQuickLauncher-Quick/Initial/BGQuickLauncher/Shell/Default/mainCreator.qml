import QtQuick 2.7
import QtQuick.Controls 2.0
import BGQuickLauncher 1.0

Page {
    id:appWin
    property alias instanceNav:instanceNav
    //visible: true
    background: Image {
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: "file:" + shellPath + "Default/imgs/wp.jpg"
    }
    LauncherStackLayout {
        id: launcherStackLayout
        anchors.fill: parent

        currentIndex: instanceNav.currentIndex
    }

    MouseArea {
        anchors.bottom: launcherStackLayout.bottom
        anchors.right: launcherStackLayout.right
        width: 64
        height: 64
        propagateComposedEvents: true
        onPressAndHold: appWin.footer.visible = !appWin.footer.visible
    }
    footer: InstanceNav { id: instanceNav }
}
