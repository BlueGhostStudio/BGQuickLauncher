import QtQuick 2.7
import BGStudio 1.0
import BGControls 1.0
import "BGCtrlStyle.js" as StyleJS
import "private/MisFun.js" as MisFun
import QtQuick.Controls 2.0

Canvas {
    id: comboBox
    property string area
    property int padding: 5
    property color color: BGCtrlStyle[area + "btnColor"]
    property alias model: popupMenu.model
    property alias currentIndex: popupMenu.currentIndex
    property alias valueField: popupMenu.valueField
    property alias displayField: popupMenu.displayField
    readonly property alias value: popupMenu.value
    readonly property int arrowSize: label.height / 2
    
    function valueIndex (v) {
        return MisFun.valueIndex (v, valueField, model);
    }
    
    contextType: "2d"
    
    implicitWidth: Math.floor (label.implicitWidth + padding * 3 + arrowSize + 10)
    implicitHeight: Math.floor (label.implicitHeight + padding * 2)
    
    onPaint: {
        var ctx = getContext ("2d");
        StyleJS["APP_btn_" + BGCtrlStyle.appearance] (ctx, color, width, height, popupMenu.visible);
        
        ctx.fillStyle = BGColor.contrast (comboBox.color, 0.5);
        var ph = (height - arrowSize) / 2;
        
        ctx.beginPath ();
        ctx.fillRect (width - padding * 2 - arrowSize - 2, ph, 1, arrowSize);
        
        ctx.beginPath ();
        ctx.moveTo (width - arrowSize - padding - 2, ph);
        ctx.lineTo (width - padding - 2, ph);
        ctx.lineTo (width - arrowSize / 2 - padding - 2, height - padding - arrowSize / 2);
        ctx.closePath ();
        ctx.fill ();
    }
    
    Text {
        id: label
        width: parent.width - padding * 2 - 15
        x: comboBox.padding + 2
        anchors.verticalCenter: parent.verticalCenter
        text: displayField ? model[currentIndex][displayField] : model[currentIndex]
        color: BGColor.contrast (comboBox.color, 0.5);
    }
    BGMenu {
        id: popupMenu
        area: comboBox.area
        //width: parent.width - 4
        x: 2
        y: parent.height
        onVisibleChanged: comboBox.requestPaint ();
    }
    MouseArea {
        anchors.fill: parent
        onClicked: popupMenu.open ()
    }
}