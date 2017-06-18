import QtQuick 2.7
import BGControls 1.0
import BGStudio 1.0
import "BGCtrlStyle.js" as StyleJS

Item {
    id: root
    property string area
    property alias blockSize: block.width
    property color blockColor: BGCtrlStyle[area + "highlight"]
    property alias grooveColor: groove.color
    property alias grooveSize: groove.height
    //property alias blockBorder: block.border
    property alias valueColor: txtValue.color
    property real minValue: 0
    property real maxValue: 100
    property real interval: 1
    property int decimals: 2
    property bool showValue: false
    property bool showGraduation: true
    readonly property real rang: maxValue - minValue
    readonly property real intervalWidth: interval * groove.width / rang
    readonly property int stepCount: rang / interval
    readonly property int step: {
        var s = value / interval
        //var s = area.mouseX / intervalWidth
        if (s < 0)
            0
        else if (s > stepCount)
            stepCount
        else
            s
    }
    
    
    property real value//: (maxValue - minValue) / 2 + minValue

    function updateValue () {
        var v = (mouseArea.mouseX - block.width / 2) * rang / groove.width + minValue
        if (v < minValue)
            value = minValue;
        else if (v > maxValue)
            value = maxValue
        else
            value = Math.round (v / interval) * interval
    }
    
    height: block.height
    
    Rectangle {
        id: groove // 槽
        color: BGColor.contrast (BGCtrlStyle[area + "bgColor"], 0.2);
        height: 4
        width: root.width - block.width
        x: block.width / 2
        y: (root.height - height ) / 2
        radius: height / 2
        Rectangle {
            height: groove.height
            width: block.x
            color: blockColor
            //border.width: height >= 4 ? 1 : 0
            //border.color: block.border.color
            radius: height / 2
            //opacity: 0.5
        }
    }
    Canvas {
        id: block
        contextType: "2d"
        width: 20
        height: 20
        x: step * intervalWidth
        z: 1
        opacity: 0.75
        onPaint: {
            StyleJS["APP_btn_" + BGCtrlStyle.appearance] (getContext ("2d"), blockColor, width, height, false, true);
        }
        Behavior on x {
            NumberAnimation {
                duration: 125
            }
        }
    }
    onBlockColorChanged: block.requestPaint ()
    /*Rectangle {
        id: block // 划块
        radius: width / 2
        width: 20
        height: width
        x: step * intervalWidth//(value - minValue) * groove.width / rang
        color: BGCtrlStyle.highlight
        border.color: "#333"
        opacity: 0.5
        z: 1
    }*/
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        /*anchors.left: groove.left
        anchors.right: groove.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom*/
        onClicked: updateValue ()
        onPositionChanged: updateValue ()
    }
    Rectangle {
        y: -height * 1.5
        anchors.horizontalCenter: block.horizontalCenter
        visible: showValue && mouseArea.pressed
        width: txtValue.width + 10
        height: txtValue.height + 10
        radius: 5
        //border.color: block.border.color
        color: blockColor
        Text {
            x: 5
            y: 5
            id: txtValue
            text: value.toFixed (decimals)
        }
    }
    
    Component {
        id: graduation
        Rectangle {
            property int step
            width: grooveSize * 2//block.width / 2
            height: width
            radius:  width / 2
            x: step * intervalWidth + (block.width - width) / 2
            y: (root.height - height) / 2
            //border.color: step > root.step ? groove.color : block.border.color
            color: step > root.step ? groove.color : blockColor
            visible: intervalWidth > width + 5
        }
    }
    Component.onCompleted: {
        console.log (area + "highlight");
        if (showGraduation) {
            for (var i = 0; i <= stepCount; i++) {
                graduation.createObject (root, {
                    step: i
                });
            }
        }
        if (value < minValue)
            value = minValue;
        else if (value > maxValue)
            value = maxValue
    }
}
