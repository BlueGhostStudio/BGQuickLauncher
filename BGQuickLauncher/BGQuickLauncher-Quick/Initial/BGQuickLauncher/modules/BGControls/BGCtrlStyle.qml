pragma Singleton
import QtQuick 2.7
import Qt.labs.settings 1.0
import BGStudio 1.0

Settings {
    category: "BGControlsStyle"
    property string appearance: "Glass"
    property color bgColor: "#ccc"
    property color btnColor: Qt.darker (bgColor, 1.2)
    property color highlight: "#27f"
    property color textColor: BGColor.contrast ("black", bgColor, 1)
    property color inputColor: "white"
    property color inputTextColor: BGColor.contrast(inputColor, 1)
    
    property color bannerbgColor: "#27f"
    property color bannerbtnColor: Qt.darker (bannerbgColor, 1.2)
    property color bannertextColor: BGColor.contrast ("black", bannerbgColor, 1)
    property color bannerhighlight: BGColor.contrast (highlight, bannerbgColor, 0.5)
    property color bannerinputColor: inputColor
    property color bannerinputTextColor: inputTextColor
    
    property color cardbgColor: "white"
    property color cardbtnColor: "#ccc"
    property color cardtextColor: "black"
    property color cardhighlight: "blue"
    property color cardinputColor: "white"
    property color cardinputTextColor: "black"
    
    
    property color selectedbgColor: highlight
    property color selectedbtnColor: Qt.darker (selectedbgColor, 1.2)
    property color selectedtextColor: BGColor.contrast (textColor, selectedbgColor, 1)
    property color selectedhighlight: BGColor.contrast (selectedbgColor, 0.5)
    property color selectedinputColor: Qt.darker (selectedbgColor, 1.2)
    property color selectedinputTextColor: BGColor.contrast(selectedinputColor, 1)
}
