import QtQuick 2.7
import QtQuick.Controls 2.0
import BGQuickLauncher 1.0
import BGStudio 1.0

ApplicationWindow {
    id:appWin
    visible: true
    title:'Minecraft'
    
    property alias launcher: launcher
    property alias appsMenu: appsMenu
    property Item activedWindow: null
    property int maxZIndex: 0
    
    background: Image {
        source: "image/wallpaper.jpg"
        fillMode: Image.PreserveAspectCrop
    }
    
    Component {
        id: winCmp
        Window {}
    }
    function setWindowActived (winObj) {
        winObj.minWin = false;
        if (activedWindow === winObj) {
            console.log ("<i><-->")
            return;
        }
        if (activedWindow)
            activedWindow.actived = false;
        
        activedWindow = winObj;
        activedWindow.actived = true;
        activedWindow.z = maxZIndex;
        maxZIndex++;
        
        panel.taskBar.currentInstance = winObj.iid;
    }
    Launcher {
        id: launcher
        onNewInstanceCreated: { // item, instance
            var winObj = winCmp.createObject (appWin.contentItem);
            item.parent = winObj.viewport;
            item.width = Qt.binding (function () { return winObj.viewport.width });
            item.height = Qt.binding (function () { return winObj.viewport.height });
            item.x = 0;
            item.y = 0;

            winObj.title = instance.appInfo.title;
            winObj.iid = instance.id;
            winObj.winX = 100;
            winObj.winY = 100;
            
            setWindowActived (winObj);
            
            winObj.activeWindow.connect (function () {
                setWindowActived (winObj);
            });
        }
    }

    header: Panel {
        id: panel
        Component.onCompleted: {
            function getInstanceWin (iid) {
                var items = appWin.contentItem.children;
                for (var x in items) {
                    if (items[x].objectName === "InstanceWindow") {
                        if (items[x].iid === iid)
                            return items[x];
                    }
                }
                return null;
            }
            taskBar.instanceActived.connect (function (iid) {
                var winObj = getInstanceWin (iid);
                if (winObj)
                    setWindowActived (winObj);
                /*var items = appWin.contentItem.children;
                for (var x in items) {
                    if (items[x].objectName === "InstanceWindow") {
                        if (items[x].iid === iid) {
                            setWindowActived (items[x]);
                            return;
                        }
                    }
                }*/
            });
            taskBar.instanceMaxWindow.connect (function (iid) {
                var winObj = getInstanceWin (iid);
                winObj.maxRestore ();
            });
        }
    }
    
    AppsMenu {
        id: appsMenu
    }
    //Component.onCompleted: showFullScreen ()
    

    /*
     * App List model: launcher.appList
     * APPOBJ: {
     *   appName: APPNAME,
     *   title: TITLE,
     *   iconSrc: ICON,
     *   description: DESC
     * }
     * New app Instance: launcher.newInstance (APP.appName);
     * INSTANCEOBJ: {
     *   id: INSTID
     *   appInfo: APPOBJ
     * }
     * Instances model: launcher.instaceList
     * Get Instance: inst = launcher.instance (INSTID)
     * Close Instance: inst.close ()
     */
}
