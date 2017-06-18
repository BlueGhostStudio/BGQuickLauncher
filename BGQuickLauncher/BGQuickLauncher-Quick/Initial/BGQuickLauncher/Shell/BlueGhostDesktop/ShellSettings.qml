import QtQuick 2.7
import QtQuick.Controls 2.0
import BGQuickLauncher 1.0
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import BGControls 1.0

BGDialog {
    title: "Shell Settings"
    
    /*Settings {
        id: settings
        category: "BlueGhostDesktop"
        property var favourite
    }*/
    
    BGFieldLayout {
        BGField {
            label: "Favorite apps"
            BGLineEdit {
                id: leFav
                //text: settings.favorite
                Component.onCompleted: {
                    var fav = favApps.settings.favourite;
                    var r = "";
                    for (var i in fav) {
                        if (i > 0)
                            r += ",";
                        r += fav[i];
                    }
                    text = r;
                }
            }
        }
    }
    
    onAccepted: {
        favApps.settings.favourite = leFav.text.split(',');
        favApps.makeList ();
    }
}
