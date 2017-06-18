import QtQuick 2.7
import QtQuick.Controls 2.0
import BGQuickLauncher 1.0

ApplicationWindow {
    id:appWin
    Launcher {
        id: launcher
    }

    /*
     * App List model: launcher.appList
     * APPOBJ: {
     *   appName: APPNAME,
     *   title: TITLE,
     *   iconSrc: ICON,
     *   description: DESC
     * }
     * New app Instance: launcher.newInstance (APP.appName);
     * when NewInstanceCreated:
     *          signal: newInstanceCreated; args: item, instance
     * INSTANCEOBJ: {
     *   id: INSTID
     *   appInfo: APPOBJ
     * }
     * Instances model: launcher.instaceList
     * Get Instance: inst = launcher.instance (INSTID)
     * Close Instance: inst.close ()
     */
}
