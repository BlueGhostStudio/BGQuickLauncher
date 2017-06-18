import QtQuick 2.7

Rectangle {
    Text {
        id: txt0
        x: (parent.width - width) / 2
        y: (parent.height - height) / 4
        text: "初始化以完成\n重启以使生效"
        font.pixelSize: 32
        font.bold: true
    }
}