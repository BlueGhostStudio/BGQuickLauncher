import QtQuick 2.7
import QtQuick.Controls 2.0
import BGQuickLauncher 1.0
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import BGControls 1.0

BGArea {
    id: rootItem
    Settings {
        id: settings
        property alias shell: txtShell.text
        property alias clearCompCache: btnClearCompCache.checked
    }
    BGFieldLayout {
        anchors.centerIn: parent
        BGField {
            label: "Shell"
            BGLineEdit { id: txtShell }
        }
        BGField {
            label: "Clear Component cache\nbefore app run"
            BGButton {
                id: btnClearCompCache
                checkable: true
                text: checked ? "ON" : "OFF"
            }
        }
    }
}
