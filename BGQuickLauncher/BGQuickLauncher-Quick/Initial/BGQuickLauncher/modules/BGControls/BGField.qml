import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import BGControls 1.0

RowLayout {
    id: field
    property string area
    property int fieldWidth: parent.maxFieldWidth
    property string label
    default property Item content
    readonly property int labelImplicitWidth: txtLabel.implicitWidth
    objectName: "BGField"
    
    Text {
        id: txtLabel
        Layout.preferredWidth: fieldWidth
        horizontalAlignment: Text.AlignRight
        text: label + ":"
        color: BGCtrlStyle[area + "textColor"]
    }
    Component.onCompleted: {
        content.parent = field
        content.Layout.fillWidth = true
    }
}
