import QtQuick 2.7
import BGCanvas 1.0
import BGControls 1.0
import BGStudio 1.0
import QtQuick.Layouts 1.3

BGCanvas {
    id: btnRoot
    property string area: ""
    property alias label: txtLabel
    property alias text: txtLabel.text
    property alias font: txtLabel.font
    property color color: BGCtrlStyle[area + "btnColor"]
    property int iconSize: 22
    property url icon
    property int padding: 5
    
    property bool checkable: false
    property bool checked: false
    
    signal clicked ()
    signal pressAndHold ()
    
    implicitWidth: Math.floor (rlLabel.implicitWidth + padding *  2 + 7)
    implicitHeight: Math.floor (rlLabel.implicitHeight + padding * 2 + 7)
    paths: [
        BGRoundedRect {
            x: 1
            y: 1
            width: btnRoot.width - 2
            height: btnRoot.height - 2
            xRadius: 5
            yRadius: 5
            fillColor: "#30000000"
        },
        BGRoundedRect {
            x: 2
            y: 2
            width: btnRoot.width - 4
            height: btnRoot.height - 4
            xRadius: 4
            yRadius: 4
            fillColor: "#90ffffff"
        },
        BGRoundedRect {
            x: 3
            y: 3
            width: btnRoot.width - 6
            height: btnRoot.height - 6
            xRadius: 3
            yRadius: 3
            fillColor: (ma.pressed || (btnRoot.checkable && btnRoot.checked)) ? BGColor.contrast (btnRoot.color, 0.2) : btnRoot.color
        },
        BGPath {
            x: 3
            y: btnRoot.height / 2
            fillColor: "#30ffffff"
            closePath: true
            elems: [
                BGCubicTo {
                    cx: btnRoot.width / 3
                    cy: btnRoot.height / 3
                    cx2: btnRoot.width * 2 / 3
                    cy2: btnRoot.height * 2 / 3
                    x: btnRoot.width - 3
                    y: btnRoot.height / 2
                },
                BGArcTo {
                    x: btnRoot.width - 9
                    y: btnRoot.height - 9
                    startAngle: 0
                    arcLength: -90
                    width: 6
                    height: 6
                },
                BGArcTo {
                    x: 3
                    y: btnRoot.height - 9
                    startAngle: -90
                    arcLength: -90
                    width: 6
                    height: 6
                }
            ]
        }
        /*BGRoundedRect {
            x: 3.5
            y: 3.6
            xRadius: 4.5
            yRadius: 4.5
            width: btnRoot.width - 7
            height: btnRoot.height - 7
            strokeColor: "#60ffffff"
        }*/
    ]
    MouseArea {
        id: ma
        anchors.fill: parent
        onPressedChanged: btnRoot.update ();
        onClicked: {
            if (checkable) {
                checked = !checked;
                btnRoot.update ();
            }
            btnRoot.clicked ();
        }
        onPressAndHold: btnRoot.pressAndHold ()
    }
    RowLayout {
        id: rlLabel
        anchors.centerIn: parent
        spacing: 0
        Image {
            Layout.preferredWidth: btnRoot.iconSize
            Layout.preferredHeight: btnRoot.iconSize
            source: btnRoot.icon
            Component.onCompleted: {
                if (btnRoot.icon.toString ().length > 0)
                    visible = true;
                else
                    visible = false;
            }
        }
        Text {
            id: txtLabel
            color: BGColor.contrast (btnRoot.color, 0.5);
        }
    }
    onColorChanged: update ()
}
