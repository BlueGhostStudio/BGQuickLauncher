import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import BGQuickLauncher 1.0

Item {
    id: rootItem
    Button {
        anchors.centerIn: parent
        text: "Click to Exit"
        onClicked: rootItem.Launcher.close ()
    }
}
