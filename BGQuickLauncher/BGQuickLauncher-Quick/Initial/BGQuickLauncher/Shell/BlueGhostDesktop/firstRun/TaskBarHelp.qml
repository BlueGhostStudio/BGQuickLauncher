import QtQuick 2.7
import QtQuick.Controls 2.0

Popup {
    id: popTaskBarHelp
    property bool first: true
    background: Rectangle {
        color: "#90000000"
    }
    
    padding: 0
    width: parent.width
    height: parent.height
    
    Text {
        id: txt0
        text: "任务栏"
        font.pixelSize: 22
        x: (parent.width - width) / 2
        y: (parent.height * 1.5 - height) / 2
        color: "white"
    }
    Text {
        id: txt1
        text: "运行中的应用实例\n点击激活"
        color: "white"
        x: 20
        y: parent.height / 2 + 10
    }
    Text {
        id: txt2
        text: "关闭"
        color: "white"
        x: parent.width - width - 20
        y: parent.height / 2 + 10
    }
    
    Text {
        id: txtKnow
        text: "知道了"
        color: "white"
        font.pixelSize: 32
        font.bold: true
        
        anchors.centerIn: parent
        anchors.verticalCenterOffset: - 64
        
        MouseArea {
            anchors.fill: parent
            onClicked: {
                popTaskBarHelp.close ();
                panel.close ();
            }
        }
    }
    Timer {
        id: timer
        interval: 500
        onTriggered: {
            panel.open ();
            popTaskBarHelp.open ();
        }
    }
    function start () {
        if (first) {
            timer.start ();
            first = false;
        }
    }
}
