import QtQuick 2.7
import QtQuick.Layouts 1.3
import BGControls 1.0

BGDialog {
    title: "Color Select"
    property color selectedColor
    property alias colorSelector: colorSelector
    
    BGColorSelector { id: colorSelector; level: 48 }
    
    onAccepted: selectedColor = colorSelector.color
}
