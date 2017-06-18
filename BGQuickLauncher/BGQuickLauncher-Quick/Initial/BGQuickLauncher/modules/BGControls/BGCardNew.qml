import QtQuick 2.7
import QtQuick.Layouts 1.3
import BGControls 1.0
import QtGraphicalEffects 1.0

Item {
    id: cardRootItem
    property alias area: areaWrap.area
    property int padding: 10
    property int radius: padding
    property int shdRadius: 10
    default property Item content
    
    implicitWidth: content.implicitWidth + (padding + shdRadius) * 2
    implicitHeight: content.implicitHeight + (padding + shdRadius) * 2
    
    BGArea {
        id: areaWrap
        anchors.fill: parent
        anchors.margins: shdRadius
        area: "card"
        radius: cardRootItem.radius
        layer.enabled: true
        layer.effect: Glow {
            radius: shdRadius
            samples: radius * 2 + 1
            color: "#30000000"
            transparentBorder: true
        }
    }
    
    Component.onCompleted: {
        content.parent = areaWrap;
        content.anchors.fill = areaWrap;
        content.anchors.margins = padding;
        areaWrap.recursion (areaWrap);
    }
}