import QtQuick 2.7
import BGStudio 1.0
import BGControls 1.0
import "BGCtrlStyle.js" as StyleJS
import QtQuick.Layouts 1.3

Canvas {
    id: button
    
    property string area: ""
    property bool checkable: false
    property bool checked: false
    property url icon
    property color color: BGCtrlStyle[area + "btnColor"]
    property alias label: label
    property alias text: label.text
    property alias font: label.font
    property int iconSize: 22
    property int padding: 5
    
    signal clicked ()
    signal pressAndHold ()
    
    implicitWidth: Math.floor (row.implicitWidth + padding * 2)
    implicitHeight: Math.floor (row.implicitHeight + padding * 2)
    
    contextType: "2d"
    
    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 0
        Image {
            Layout.preferredWidth: iconSize
            Layout.preferredHeight: iconSize
            source: icon
            Component.onCompleted: {
                if (icon.toString ().length > 0)
                    visible = true;
                else
                    visible = false;
            }
        }
        Text {
            id: label
            color: BGColor.contrast (button.color, 0.5);
            visible: text.length > 0
            font.pixelSize: 22
            font.bold: true
        }
    }
    
    onWidthChanged: button.requestPaint ()
    onHeightChanged:  button.requestPaint ()
    onColorChanged: button.requestPaint ()
    
    onPaint: {
        var state = false;
        if (checkable)
            state = checked;
        else
            state = mouseArea.pressed;
        StyleJS["APP_btn_" + BGCtrlStyle.appearance] (getContext ("2d"), color, width, height, state);
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onReleased: { requestPaint (); }
        onPressed: { requestPaint ();}
        onClicked: {
            if (checkable) {
                checked = !checked;
                requestPaint ();
            }
            button.clicked ();
        }
        onPressAndHold: button.pressAndHold ()
    }
}
