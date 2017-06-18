import QtQuick 2.7
import QtQuick.Layouts 1.3
import BGControls 1.0
Rectangle {
    BGColorDialog {
        id: colorDialog
        property var callback: null
        colorSelector.level: 48
        onAccepted: { if (callback) callback (selectedColor) }
    }
    
    ColumnLayout {
        width: parent.width
        BGRadioGroup {
            id: rgArea
            horizontal: true
            displayField: "d"
            valueField: "v"
            model: [{ d: "Base", v: "" },
            { d: "Banner", v: "banner" },
            { d: "Card", v: "card" }]
        }
        Flow {
            Layout.fillWidth: true
            ColorButton {
                text: "Background"
                colorItem: "bgColor"
            }
            ColorButton {
                text: "Button"
                colorItem: "btnColor"
            }
            ColorButton {
                text: "Text Color"
                colorItem: "textColor"
            }
            ColorButton {
                text: "Input Color"
                colorItem: "inputColor"
            }
            ColorButton {
                text: "Input Text Color"
                colorItem: "inputTextColor"
            }
            ColorButton {
                text: "Highlight"
                colorItem: "highlight"
            }
        }
        
        BGArea {
            Layout.fillWidth: true
            Layout.margins: 20
            implicitHeight: clSample.implicitHeight + 10
            area: rgArea.value
            ColumnLayout {
                id: clSample
                anchors.fill: parent
                anchors.margins: 5
                BGButton { text: "button"; Layout.fillWidth: true; }
                BGLineEdit {Layout.fillWidth: true}
                BGRadioGroup {
                    model: ["opt1", "opt2", "opt3"];
                    horizontal: true;
                    Layout.fillWidth: true }
                BGSliderStep { width: 120; maxValue: 10;Layout.fillWidth: true }
            }
        }
    }
    color: BGCtrlStyle.bgColor
}
