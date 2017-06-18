import QtQuick 2.7
import BGControls 1.0

Canvas {
    onPaint: {
        var ctx = getContext ("2d");
        ctx.reset ();
        ctx.save ();
        
        ctx.fillStyle = BGCtrlStyle.bgColor;
        ctx.shadowBlur = 5;
        ctx.shadowColor = "#60000000";
        ctx.fillRect (0, height, width, 10);
        
        ctx.restore ();
        ctx.fillStyle = "#60ffffff";
        ctx.fillRect (0, height - 1, width, 1);
    }
}