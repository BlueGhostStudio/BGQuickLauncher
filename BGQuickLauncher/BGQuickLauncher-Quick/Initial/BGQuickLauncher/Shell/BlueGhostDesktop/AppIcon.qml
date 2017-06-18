import QtQuick 2.0
import QtGraphicalEffects 1.0
import BGQuickLauncher 1.0
import BGStudio 1.0

Rectangle {
    id: iconRootItem
    property var app
    width: row.width + 10
    height: row.height + 10
    color: "#60ffffff"
    signal clicked ()
    radius: 5
    Row {
        id: row
        spacing: 5
        anchors.centerIn: parent
        /*layer.enabled: true
        layer.effect: Glow {
            radius: 2
            samples: 5
            color: "#c0ffffff"
        }*/
        Image {
            id: imgIcon
            width: 48
            height: 48
            source: appsPath + app.appName + "/" + app.iconSrc
            onStatusChanged: if (status == Image.Error) {
                                 source = BGIcons.icon ("default");
                             }
        }
        Column {
            anchors.verticalCenter: parent.verticalCenter
            Text {
                text: app.title
                font.pixelSize: 14
                font.bold: true
                //color: "white"
                width: Math.min(implicitWidth, 128)
                elide: Text.ElideRight
            }
            Text {
                text: app.description
                font.pixelSize: 10
                //color: "white"
                width: Math.min(implicitWidth, 128)
                elide: Text.ElideRight
                wrapMode: Text.Wrap
            }
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            launcher.newInstance(app.appName);
            iconRootItem.clicked ();
        }
    }
}