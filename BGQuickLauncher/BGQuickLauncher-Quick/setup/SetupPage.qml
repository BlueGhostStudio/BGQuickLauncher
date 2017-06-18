import QtQuick 2.7
import QtQuick.Controls 2.0
import BGStudio 1.0
import "CopyFiles.js" as CF

Page {
    Component {
        id: settingPage
        SettingPage {}
    }
    header: Rectangle {
        color: "#ccc"
        height: 48
        Text {
            anchors.centerIn: parent
            text: "Initial..."
            font.pixelSize: 32
            font.bold: true
        }
    }
    BusyIndicator {
        anchors.centerIn: parent
    }
    Timer {
        id: timer
        interval: 500
        onTriggered: {
            CF.copyAllFiles ("qrc:///Initial/BGQuickLauncher",
                "BGQuickLauncher", CF.launcherPath);
            BGFile.mkpath (CF.launcherPath + "/data");
            mainStackView.push (settingPage);
        }
    }
    StackView.onStatusChanged: {
        if (StackView.status == StackView.Active) {
            BGFile.mkpath (CF.launcherPath);
            BGFile.mkpath (CF.pluginsPath);
            timer.start ();
        }
    }
}
