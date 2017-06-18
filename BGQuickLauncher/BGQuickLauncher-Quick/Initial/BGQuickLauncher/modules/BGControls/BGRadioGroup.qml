import QtQuick 2.7
import QtQuick.Layouts 1.3
import BGControls 1.0
import BGStudio 1.0
import "BGCtrlStyle.js" as StyleJS
import "private/MisFun.js" as MisFun

GridLayout {
    id: radioGroup
    property string area
    property alias model: repeater.model
    property color color: BGCtrlStyle[area + "btnColor"]
    property color highlight: BGCtrlStyle[area + "highlight"]
    property color textColor: BGCtrlStyle[area + "textColor"]
    property int currentIndex: 0
    property bool horizontal: false
    
    signal clicked (var value)
    
    property string displayField
    property string valueField
    readonly property var value: MisFun.value (currentIndex, valueField, model)//currentIndex >= 0 ? (valueField ? model[currentIndex][valueField] : currentIndex) : null
    
    function valueIndex (v) {
        return MisFun.valueIndex (v, valueField, model);
    }
    
    columns: horizontal ? -1 : 1
    rows: horizontal ? 1 : -1
    Repeater {
        id: repeater
        RowLayout {
            spacing: 2
            Canvas {
                id: cvsBtn
                property int actived: currentIndex === index ? width - 8 : 0
                width: 18
                height: 18
                contextType: "2d"
                
                onActivedChanged: requestPaint ();
                Behavior on actived {
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.InOutBack
                    }
                }
                
                onPaint: {
                    var ctx = getContext ("2d");
                    StyleJS["APP_btn_" + BGCtrlStyle.appearance] (ctx, color, width, height, false, true);
                    
                    ctx.beginPath ();
                    var _x = (width - actived) / 2;
                    var r = actived / 2;
                    ctx.fillStyle = highlight//Qt.rgba(highlight.r, highlight.g, highlight.b, 0.5);
                    ctx.roundedRect (_x, _x, actived, actived, r, r);
                    ctx.fill ();
                }
                
                Component.onCompleted: {
                    radioGroup.highlightChanged.connect (function () { cvsBtn.requestPaint () });
                    radioGroup.colorChanged.connect (function () { cvsBtn.requestPaint () });
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        radioGroup.currentIndex = index;
                        radioGroup.clicked (radioGroup.value);
                    }
                }
            }
            Text {
                text: displayField ? modelData[displayField] : modelData
                color: radioGroup.currentIndex == index ? highlight : textColor;
                Behavior on color {
                    ColorAnimation { duration: 250 }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        radioGroup.currentIndex = index;
                        radioGroup.clicked (radioGroup.value);
                    }
                }
            }
        }
    }
}
