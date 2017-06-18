import QtQuick 2.2

Item {
    id: root
    property alias blockSize: block.width
    property alias blockColor: block.color
    property alias grooveColor: groove.color
    property alias blockBorder: block.border
    property alias valueColor: txtValue.color
    property int minValue: 0
    property int maxValue: 100
    readonly property int rang: maxValue - minValue
    
    property int value//: (maxValue - minValue) / 2 + minValue

    function updateValue () {
        var v = area.mouseX * rang / groove.width + minValue
        if (v < minValue)
            value = minValue;
        else if (v > maxValue)
            value = maxValue
        else
            value = v
    }
    
    height: block.height
    
    Rectangle {
        id: groove // 槽
        color: "#999"
        height: 2
        width: root.width - block.width
        x: block.width / 2
        y: (root.height - height ) / 2
        radius: height / 2
        Rectangle {
            height: groove.height
            width: block.x
            color: block.color//Qt.rgba(1-groove.color.r,1-groove.color.g,1-groove.color.b,1)
            radius: height / 2
            opacity: 0.5
        }
    }
    Rectangle {
        id: block // 划块
        radius: width / 2
        width: 20
        height: width
        x: (value - minValue) * groove.width / rang
        color: "skyblue"
        border.color: "black"
    }
    MouseArea {
        id: area
        anchors.fill: parent
        onClicked: updateValue ()
        onPositionChanged: updateValue ()
    }
    Rectangle {
        y: -height * 1.5
        anchors.horizontalCenter: block.horizontalCenter
        visible: area.pressed
        width: txtValue.width + 10
        height: txtValue.height + 10
        radius: 5
        border.color: block.border.color
        color: block.color
        Text {
            x: 5
            y: 5
            id: txtValue
            text: value
        }
    }
    Component.onCompleted: {
        if (value < minValue)
            value = minValue;
        else if (value > maxValue)
            value = maxValue
    }
}