import QtQuick 2.7
import BGStudio 1.0
import BGControls 1.0
import QtQuick.Window 2.2
import "BGCtrlStyle.js" as StyleJS

Canvas {
    id: lineEdit
    property string area
    
    property int padding: 5
    property color color: BGCtrlStyle[area + "inputColor"]
    property color textColor: BGCtrlStyle[area + "inputTextColor"]
    property color selectionColor: BGCtrlStyle[area + "highlight"]
    property color selectedTextColor: BGColor.contrast (BGCtrlStyle[area + "textColor"], selectionColor, 0.5)
    
    property Item input
    property alias editMenu: editMenu
    function openEditMenu () {
        var selStart = input.selectionStart;
        var selEnd = input.selectionEnd;
        
        var g = input.mapToGlobal (0, 0);
        g.x += input.cursorRectangle.x;
        g.y += input.cursorRectangle.y;
        var offsetRight = Screen.desktopAvailableWidth
            - (g.x + editMenu.width);
        var offsetBottom = Screen.desktopAvailableHeight
            - (g.y + editMenu.height);
        if (offsetRight >= 0)
            offsetRight = 0;
        if (offsetBottom >= 0)
            offsetBottom = 0;
        editMenu.x = input.cursorRectangle.x + offsetRight;
        editMenu.y = input.cursorRectangle.y + offsetBottom;
        
        editMenu.open ();
        
        input.select (selStart, selEnd);
    }
    
    signal editingFinished ()
    
    width: 200
    contextType: "2d"
    onPaint: {
        StyleJS["APP_input_" + BGCtrlStyle.appearance] (getContext ("2d"), color, width, height, padding);
    }
    onWidthChanged: lineEdit.requestPaint ()
    onHeightChanged:  lineEdit.requestPaint ()
    onColorChanged: lineEdit.requestPaint ()
    
    
    BGMenu {
        id: editMenu
        model: ["Select All", "Copy", "Cut", "Paste"]
        onActived: {
            switch (value) {
            case 0:
                input.selectAll ();
                break;
            case 1:
                input.copy ();
                break;
            case 2:
                input.cut ();
                break;
            case 3:
                input.paste ();
                break
            }
        }
    }
}
