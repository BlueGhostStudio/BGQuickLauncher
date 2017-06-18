import QtQuick 2.7
import BGStudio 1.0

Canvas {
    id: btn
    property int shadowRadius: tabBar.shadowRadius
    property int margin: shadowRadius + 0.5
    property int padding: tabBar.tabPadding
    property int radius: tabBar.tabRadius
    property bool actived: tabBar.currentIndex === index
    property alias label: label.text
    
    contextType: "2d"
    
    width: Math.floor (label.width + (padding + margin) * 2)
    height: Math.floor (label.height + margin + padding * 2)
    
    onPaint: {
        var ctx = getContext ("2d");
        ctx.reset ();
        ctx.save ();
        if (actived) {
            ctx.strokeStyle = "#60ffffff";
            ctx.fillStyle = tabBar.color;
            
            ctx.save ();
            
            ctx.shadowBlur = shadowRadius;
            ctx.shadowColor = "#60000000";
            
            ctx.beginPath ();
            ctx.moveTo (margin, height - 1);
            ctx.arc (margin + radius, margin + radius, radius, Math.PI, Math.PI * 3 / 2, false);
            ctx.arc (width - margin - radius, margin + radius, radius, Math.PI * 3 / 2, 2 * Math.PI, false);
            ctx.lineTo (width - margin, height - 1);
            ctx.fill ();
            
            ctx.restore ();
            ctx.stroke ();
            ctx.fillRect (margin, height - 2, width - (margin) * 2, 5);
        }
    }
    
    Text {
        id: label
        y: btn.margin + btn.padding
        anchors.horizontalCenter: parent.horizontalCenter
        text: tabBar.displayField.length > 0
            ? modelData[tabBar.displayField] : modelData
        color: actived ? BGColor.contrast (tabBar.color, 0.5) : BGColor.contrast (tabBar.bgColor, 0.2);
        font: tabBar.font
    }
    
    MouseArea {
        anchors.fill: parent
        onClicked: tabBar.currentIndex = index
    }
    
    onActivedChanged: {
        requestPaint ();
    }
    
    //paintScript: function (p) {
        //if (actived) {
            /*p.setPen (MisFun.borderColor (color));
            p.setBrush (tabBar.color);
            p.setShadowEnabled (true, "#60000000", shadowRadius);
            
            p.beginPath ();
            p.moveTo (margin, height);
            p.arcTo (margin, margin, radius, radius, 180, -90);
            p.arcTo (width - margin - radius, margin, radius, radius, 90, - 90);
            p.lineTo (width - margin, height);
            p.drawPath ();*/
            
            //p.drawRoundRect (margin, margin, width - margin * 2, height - margin * 2, 5);
        //}
    //}
    
}
