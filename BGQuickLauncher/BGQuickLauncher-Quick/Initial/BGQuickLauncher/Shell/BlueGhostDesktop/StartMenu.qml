import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import BGControls 1.0

StackView {
    id: stvMenu
    Component {
        id: appsMenu
        AppsMenu {}
    }
    function openAppsMenu (cate) {
        stvMenu.push (appsMenu, { category: cate });
    }
    function backToCateMenu () {
        stvMenu.pop ();
    }
    
    clip: true
    Layout.fillWidth: true
    Layout.fillHeight: true
    initialItem: CateMenu {
    }
}