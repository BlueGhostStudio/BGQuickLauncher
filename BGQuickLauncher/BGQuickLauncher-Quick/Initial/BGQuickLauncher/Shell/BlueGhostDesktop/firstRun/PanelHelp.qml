import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Popup {
    id: popPanelHelp
    property bool first: true
    background: Rectangle {
        color: "#90000000"
    }
    
    padding: 0
    width: parent.width
    height: parent.height
    
    Text {
        id: txt0
        text: "分类"
        font.pixelSize: 22
        x: (parent.width * 0.3 - width) / 2
        y: (parent.height / 2 - height) / 2
        color: "white"
    }
    Text {
        id: txt1
        text: "应用"
        font.pixelSize: 22
        x: parent.width * 0.65 - width * 0.5
        y: (parent.height / 2 - height) / 2
        color: "white"
    }
    RowLayout {
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 80
        Text {
            Layout.preferredWidth: 48
            text: "回到\n桌面"
            color: "white"
        }
        Text {
            Layout.preferredWidth: 48
            text: "Shell\n属性"
            color: "white"
        }
        Text {
            Layout.preferredWidth: 48
            text: "刷新\n应用\n菜单"
            color: "white"
        }
    }
    Text {
        id: txtKnow
        text: "知道了"
        color: "white"
        font.pixelSize: 32
        font.bold: true
        
        anchors.centerIn: parent
        
        MouseArea {
            anchors.fill: parent
            onClicked: popPanelHelp.close ()
        }
    }
    
    function start () {
        if (first) {
            open ();
            first = false;
        }
    }
}
