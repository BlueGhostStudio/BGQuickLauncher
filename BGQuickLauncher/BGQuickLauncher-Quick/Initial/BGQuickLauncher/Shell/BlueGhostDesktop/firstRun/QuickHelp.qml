import QtQuick 2.7
import Qt.labs.settings 1.0
import QtQuick.Controls 2.0

Item {
    Component {
        id: homeHelpCmp
        HomeHelp {}
    }
    Component {
        id: panelHelpCmp
        PanelHelp {}
    }
    Component {
        id: taskBarHelpCmp
        TaskBarHelp {}
    }
    
    Settings {
        id: settings
        category: "BlueGhostDesktop"
        property var firstRun: true
    }
    
    property Popup homeHelp
    property Popup panelHelp
    property Popup taskBarHelp
    function start () {
        if (settings.firstRun == true) {
            favApps.settings.favourite = [
                "FileManager",
                "BGQLCreator",
                "editor",
                "MiniWebBrower","BGMediaPlayer"
            ];
            favApps.makeList ();
            
            homeHelp = homeHelpCmp.createObject (appWin.overlay);
            panelHelp = panelHelpCmp.createObject (appWin.overlay);
            taskBarHelp = taskBarHelpCmp.createObject (appWin.overlay);
            panel.opened.connect (function () {
                panelHelp.start ();
            });
            launcher.instanceListChanged.connect (function () {
                taskBarHelp.start ();
            });
            
            homeHelp.start ();
            settings.firstRun = false;
        }
    }
}