import QtQuick 2.7
import BGStudio 1.0
import BGControls 1.0

BGButton {
    property string ch
    padding: 5
    width: label.width < 22 ? 32 : label.width + 10
    height: 32
    text: ch
    onClicked: {
        edit.edit.insert (edit.edit.cursorPosition, ch);
    }
}
