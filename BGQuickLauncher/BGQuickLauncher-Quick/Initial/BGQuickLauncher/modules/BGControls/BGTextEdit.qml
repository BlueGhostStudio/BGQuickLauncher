import QtQuick 2.7
import QtQuick.Controls 2.0

BGTextInputBase {
    id: textEdit
    property alias text: input.text
    input: input
    width: 200
    height: 200
    
    Flickable {
        id: flickable
        anchors.fill: parent
        anchors.margins: padding
        contentHeight: input.height
        clip: true
        
        function ensureVisible(r)
        {
           if (contentY >= r.y)
               contentY = r.y;
           else if (contentY+height <= r.y+r.height)
               contentY = r.y+r.height-height;
        }
        
        TextArea {
            id: input
            clip: true
            color: textColor
            width: flickable.width
            height: Math.max (implicitHeight, flickable.height)
            wrapMode: TextEdit.Wrap
            
            selectionColor: textEdit.selectionColor
            selectedTextColor: textEdit.selectedTextColor
            
            onTextChanged: {
                if (focus)
                    textEdit.editingFinished ();
            }
            onPressAndHold: openEditMenu ()
            onCursorRectangleChanged: flickable.ensureVisible(cursorRectangle)
        }
        
    }
}
