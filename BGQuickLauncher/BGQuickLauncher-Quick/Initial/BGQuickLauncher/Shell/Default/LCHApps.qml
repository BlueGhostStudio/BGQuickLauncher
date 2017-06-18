import QtQuick 2.7
import QtQuick.Controls 2.0
import BGQuickLauncher 1.0

FlowView {
    id: appsView
    signal newInstanceCreated (Item instItem)
    property Launcher launcher: Launcher {
        onNewInstanceCreated: appsView.newInstanceCreated (item)
    }
    flow.spacing: 10
    model: launcher.appList

    delegate: AppIcon_AppsView { app: modelData }

}
