import QtQuick 2.7
import QtQuick.Layouts 1.3
import BGControls 1.0
import BGStudio 1.0
import BGQuickLauncher 1.0
import QtQuick.Controls 2.0

BGPage {
    id: creatorRootItem
    
    background: Rectangle {
        color: BGCtrlStyle.bannerbgColor
    }
    
    Component {
        id: homePage
        HomePage {}
    }
    
    StackView {
        anchors.fill: parent
        initialItem: homePage
        clip: true
    }
}
