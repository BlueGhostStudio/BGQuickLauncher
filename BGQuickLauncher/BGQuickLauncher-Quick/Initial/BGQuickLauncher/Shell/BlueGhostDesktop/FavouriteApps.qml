import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0

Flickable {
    property alias settings: settings
    contentHeight: flwFavApps.height
    clip: true
    Settings {
        id: settings
        category: "BlueGhostDesktop"
        property var favourite
    }
    function makeList () {
        var fav = settings.favourite;
        var result = [];
        var apps = launcher.appList;
        for (var i in fav) {
            for (var j in apps) {
                if (fav[i] === apps[j].appName)
                    result.push (apps[j]);
            }
        }
        repeater.model = result
    }
    Flow {
        id: flwFavApps
        width: parent.width
        spacing: 10
        Repeater {
            id: repeater
            AppIcon { app: modelData}
        }
    }
    Component.onCompleted: {
        panel.reloadedApps.connect (makeList);
        makeList ();
    }
}
