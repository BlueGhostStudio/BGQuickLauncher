import QtQuick 2.0
import QtQuick.Controls 2.0

TabButton {
    id: btn
    background: Rectangle { color:"#30000000" }
    contentItem: Label {
        color: "white"
        horizontalAlignment: "AlignHCenter"
        text: btn.text
        font: btn.font
    }
}
