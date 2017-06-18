import QtQuick 2.7
import QtQuick.Controls 2.0

BGTextInputBase {
    id: lineEdit
    property alias text: txtInput.text
    input: txtInput
    
    height: txtInput.height
    
    TextField {
        id: txtInput
        background: Item {}
        clip: true
        width: lineEdit.width
        padding: lineEdit.padding
        anchors.centerIn: parent
        color: textColor
        selectionColor: lineEdit.selectionColor
        selectedTextColor: lineEdit.selectedTextColor
        
        onTextChanged: {
            if (focus)
                lineEdit.editingFinished ();
        }
        onPressAndHold: openEditMenu ()
    }
}
