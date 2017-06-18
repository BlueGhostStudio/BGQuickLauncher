import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

Rectangle {
    property color bgColor: "white"
    property color textColor: "black"
    
    y: -flickable.contentY
    height: flickable.contentHeight
    width: 32
    color: bgColor
    Repeater {
        id: repeater
        model: tep.lineNumber
        Text {
            x: 2
            y: textEdit.positionToRectangle (modelData).y
            id: txtLN
            width: 28
            horizontalAlignment: Text.AlignRight
            text: index + 1
            font.family: fixedFont.name
            font.pixelSize: fontSize
            color: textColor
            Component.onCompleted: {
                textEdit.widthChanged.connect (function () {
                    if (modelData !== undefined)
                        y = textEdit.positionToRectangle (modelData).y;
                });
            }
        }
    }
}