import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import BGControls 1.0
import BGStudio 1.0
import "Data.js" as Data

BGPage {
    property var hbData
    property Item shellWidget: ShellWidget {
    }
    function setupWidget (widgetsArea) {
        widgetsArea.addWidget (shellWidget);
    }
 
    /*header: BGArea {
        area: "banner"
        height: 48
        RowLayout {
            width: parent.width
            anchors.centerIn: parent
            BGText {
                text: "HandBook"
                font.pixelSize: 32
                font.bold: true
            }
            Item { Layout.fillWidth: true }
            BGButton {
                icon: BGIcons.icon ("save", color)
                onClicked: Data.save ()
            }
        }
    }*/
    StackView {
        id: stvMain
        anchors.fill: parent
        initialItem: CatePage {}
    }
    Component.onCompleted: Data.init ();
    Component.onDestruction: shellWidget.destroy ();
}
