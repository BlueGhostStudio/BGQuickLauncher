import QtQuick 2.0
import QtGraphicalEffects 1.0
import BGQuickLauncher 1.0

Item {
    property var app
    width: row.width
    height: row.height
    Row {
        id: row
        spacing: 5
        layer.enabled: true
        layer.effect: Glow {
            radius: 2
            samples: 5
            color: "#c0000000"
        }
        Image {
            id: imgIcon
            width: 64
            height: 64
            source: appsPath + app.appName + "/" + app.iconSrc
            onStatusChanged: if (status == Image.Error) {
                                 source = "imgs/ghost.png"
                             }
        }
        Column {
            anchors.verticalCenter: parent.verticalCenter
            Text {
                text: app.title
                font.pixelSize: 14
                font.bold: true
                color: "white"
                width: Math.min(implicitWidth, 128)
                elide: Text.ElideRight
            }
            Text {
                text: app.description
                font.pixelSize: 10
                color: "white"
                width: Math.min(implicitWidth, 128)
                elide: Text.ElideRight
                wrapMode: Text.Wrap
            }
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: launcher.newInstance(app.appName)
    }
}
