import QtQuick 2.0
import QtQuick.Controls 2.0

TabBar {
    id: instanceNav
    visible: false
    background: Item {}
    InstButton {
        text: "Luncher"
    }

    Repeater {
        model: launcherStackLayout.launcher.instanceList
        InstButton {
            text: modelData.appInfo.title
            onPressAndHold: launcherStackLayout.launcher.instance(modelData.id).close ()
        }
    }
}
