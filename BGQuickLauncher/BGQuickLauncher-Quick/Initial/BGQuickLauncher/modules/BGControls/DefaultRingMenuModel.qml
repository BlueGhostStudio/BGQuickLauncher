import QtQuick 2.7
import BGControls 1.0
import BGStudio 1.0

RingMenuDelegateModel {
    id: rootItem
    property var menuItems
    property string displayField
    property string valueField
    property font font
    
    model: menuItems
    Rectangle {
        id: txt
        color: BGCtrlStyle.bgColor
        border.color: BGColor.contrast (color, 0.75);
        width: menu.itemWidth
        height: menu.itemHeight
        antialiasing: true
        radius: Math.min (width, height)
        Text {
            anchors.fill: parent
            anchors.margins: 5
            text: displayField.length > 0
                ? modelData[displayField] : modelData
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: BGCtrlStyle.textColor
            fontSizeMode: Text.Fit
            font: rootItem.font
        }
        Behavior on opacity {
            NumberAnimation { duration: 500 }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (valueField.length > 0)
                    menu.accepted (menu.modelData[valueField],
                        level, index);
                else
                    menu.accepted (index, level, index);
            }
        }
    }
}
