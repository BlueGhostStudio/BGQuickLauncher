import QtQuick 2.7
import BGControls 1.0

BGButton {
    id: btnColor
    //text: "Color"
    
    property string colorItem
    color: BGCtrlStyle[rgArea.value + colorItem]
    onClicked: {
        colorDialog.colorSelector.setColor (color);
        colorDialog.callback = function (c) {
            //color = c
            BGCtrlStyle[rgArea.value + colorItem] = c
        }
        colorDialog.open ();
    }
}