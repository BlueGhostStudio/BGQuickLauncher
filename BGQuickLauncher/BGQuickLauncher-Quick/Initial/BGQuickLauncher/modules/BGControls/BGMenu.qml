import QtQuick 2.7
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import BGControls 1.0
import BGStudio 1.0
import "private/MisFun.js" as MisFun

Popup {
    id: popup
    property string area
    property alias model: lvMenu.model
    property color color: BGCtrlStyle[area + "bgColor"]
    property color textColor: BGCtrlStyle[area + "textColor"]
    property color highlight: BGCtrlStyle[area + "highlight"]
    property string displayField
    property string valueField
    property alias currentIndex: lvMenu.currentIndex
    property int maxItemWidth: 0
    readonly property var value: MisFun.value (currentIndex, valueField, model)
    
    signal actived (var value)
    
    function valueIndex (v) {
        return MisFun.value (v, valueField, model);
    }
    
    background: Rectangle {
        color: popup.color
        layer.enabled: true
        layer.effect: Glow {
            radius: 5
            samples: 11
            color: "#60000000"
            transparentBorder: true
        }
    }
    width: maxItemWidth + padding * 2
    height: Math.min (200, lvMenu.contentHeight) + padding * 2
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    ListView {
        id: lvMenu
        anchors.fill: parent
        clip: true
        //highlight: Rectangle { color: popup.highlight }

        delegate: Item {
            width: lvMenu.width
            height: txtMenuItem.height + 10
            Text {
                id: txtMenuItem
                anchors.centerIn: parent
                text: popup.displayField ? modelData[popup.displayField] : modelData
                //color: parent.ListView.isCurrentItem ? BGColor.contrast (popup.textColor, popup.highlight, 0.5) : popup.textColor
                color: popup.textColor
                Component.onCompleted: {
                    popup.maxItemWidth = Math.max (implicitWidth + 10, popup.maxItemWidth);
                }
            }

            MouseArea {
                anchors.fill: parent
                onPressed: txtMenuItem.font.bold = true
                onReleased: txtMenuItem.font.bold = false
                onClicked: {
                    lvMenu.currentIndex = index
                    popup.actived (popup.value)
                    popup.close ()
                }
            }

        }

    }

}
