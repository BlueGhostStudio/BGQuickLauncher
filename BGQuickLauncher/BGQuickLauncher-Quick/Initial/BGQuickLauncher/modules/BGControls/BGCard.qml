import QtQuick 2.7
import QtQuick.Layouts 1.3
import BGControls 1.0
import QtGraphicalEffects 1.0

BGArea {
    id: cardRootItem
    area: "card"
    property int padding: 10
    property int radius: padding
    property int shdRadius: 10
    property color cardColor: BGCtrlStyle.cardbgColor
    default property Item content
    
    color: "transparent"
    
    implicitWidth: card.implicitWidth + shdRadius * 2 + 4
    implicitHeight: card.implicitHeight + shdRadius * 2 + 4
    
    Canvas {
        id: card
        //area: "card"
        
        implicitWidth: content.implicitWidth + padding * 2
        implicitHeight: content.implicitHeight + padding * 2
        anchors.fill: parent
        
        contextType: "2d"
        onPaint: {
            var ctx = getContext ("2d");
            ctx.fillStyle = cardRootItem.cardColor;
            if (shdRadius > 0) {
                ctx.shadowBlur = shdRadius;
                ctx.shdowColor = "#30000000";
            }
            
            var _xy = shdRadius + 2;
            var _w = width - _xy * 2;
            var _h = height - _xy * 2;
            if (radius > 0)
                ctx.roundedRect (_xy, _xy, _w, _h, radius, radius);
            else
                ctx.rect (_xy, _xy, _w, _h);
            
            ctx.fill ();
        }
    }
    
    Component.onCompleted: {
        content.parent = cardRootItem;
        content.anchors.fill = cardRootItem;
        content.anchors.margins = padding + shdRadius + 2;
        recursion (content);
    }
}