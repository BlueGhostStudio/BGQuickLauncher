import QtQuick 2.7
import BGStudio 1.0
import BGControls 1.0

BGButton {
    property int keyCode
    property int mKey: 0
    font.pixelSize: 22
    padding: 5
    width: label.width < 22 ? 32 : label.width + 10
    height: 32
    onClicked: {
        var m = mKey;
        if (extKeyBoard.isSel)
            m |= Qt.ShiftModifier;
        BGEvent.postEventKey (edit.edit, BGEvent.KeyPress,
            keyCode, m);
    }
}
