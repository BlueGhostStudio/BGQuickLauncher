import QtQuick 2.7
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import BGControls 1.0

Drawer {
    id: drawerRootItem
    property color color: BGCtrlStyle.bgColor
    background: Rectangle {
        color: drawerRootItem.color
        layer.enabled: true
        layer.effect: Glow {
            radius: 5
            samples: 11
            color: "#60000000"
            transparentBorder: true
        }
    }
    
}
