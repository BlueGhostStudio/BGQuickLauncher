import QtQuick 2.7
import QtQuick.Layouts 1.3
import BGControls 1.0
import QtQuick.Window 2.2

RowLayout {
    id: extKeyBoard
    //property alias isSel: btnSel.checked
    property bool isSel
    spacing: 0
    Component {
        id: tabCharKeys
        Flow {
            spacing: 0
            EditKey {
                text: "⇥"; keyCode: Qt.Key_Tab
            }
            EditKey {
                text: "⇤"; keyCode: Qt.Key_Backtab
            }
            CharKey {
                ch: ":"
            }
            CharKey {
                ch: ";"
            }
            CharKey {
                ch: "."
            }
            CharKey {
                ch: ","
            }
            CharKey {
                ch: "("
            }
            CharKey {
                ch: ")"
            }
            CharKey {
                ch: "{"
            }
            CharKey {
                ch: "}"
            }
            CharKey {
                ch: "["
            }
            CharKey {
                ch: "]"
            }
            CharKey {
                ch: "'"
            }
            CharKey {
                ch: "\""
            }
            CharKey {
                ch: "\\"
            }
            CharKey {
                ch: "!"
            }
            CharKey {
                ch: "?"
            }
            CharKey {
                ch: "#"
            }
            CharKey {
                ch: "-"
            }
            CharKey {
                ch: "+"
            }
            CharKey {
                ch: "*"
            }
            CharKey {
                ch: "/"
            }
            CharKey {
                ch: "|"
            }
            CharKey {
                ch: "&"
            }
            CharKey {
                ch: "^"
            }
            CharKey {
                ch: "~"
            }
            CharKey {
                ch: "$"
            }
            CharKey {
                ch: "="
            }
            CharKey {
                ch: ">"
            }
            CharKey {
                ch: "<"
            }
            CharKey {
                ch: "_"
            }
            CharKey {
                ch: "1"
            }
            CharKey {
                ch: "2"
            }
            CharKey {
                ch: "3"
            }
            CharKey {
                ch: "4"
            }
            CharKey {
                ch: "5"
            }
            CharKey {
                ch: "6"
            }
            CharKey {
                ch: "7"
            }
            CharKey {
                ch: "8"
            }
            CharKey {
                ch: "9"
            }
            CharKey {
                ch: "0"
            }
        }
    }
    Component {
        id: mobileCharKeys
        Flow {
            spacing: 0
            EditKey {
                text: "⇥"; keyCode: Qt.Key_Tab
                font.pixelSize: 12
                width: 27
                height: 27
            }
            EditKey {
                text: "⇤"; keyCode: Qt.Key_Backtab
                font.pixelSize: 12
                width: 27
                height: 27
            }
            CharKey {
                ch: ":"
                font.pixelSize: 12
                width: 27
                height: 27
            }
            CharKey {
                ch: ";"
                font.pixelSize: 12
                width: 27
                height: 27
            }
            CharKey {
                ch: "'"
                font.pixelSize: 12
                width: 27
                height: 27
            }
            CharKey {
                ch: "\""
                font.pixelSize: 12
                width: 27
                height: 27
            }
            CharKey {
                ch: "("
                font.pixelSize: 12
                width: 27
                height: 27
            }
            CharKey {
                ch: ")"
                font.pixelSize: 12
                width: 27
                height: 27
            }
            CharKey {
                ch: "{"
                font.pixelSize: 12
                width: 27
                height: 27
            }
            CharKey {
                ch: "}"
                font.pixelSize: 12
                width: 27
                height: 27
            }
            CharKey {
                ch: "["
                font.pixelSize: 12
                width: 27
                height: 27
            }
            CharKey {
                ch: "]"
                font.pixelSize: 12
                width: 27
                height: 27
            }

        }
    }
    Component {
        id: tabModKeys
        GridLayout {
            property alias btnSel: btnSel
            rows: 3
            columns: 3
            rowSpacing: 0
            columnSpacing: 0
            EditKey {
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                text: "❰❰"
                keyCode: Qt.Key_Left
                mKey: Qt.ControlModifier
            }
            EditKey {
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                text: "▲"
                keyCode: Qt.Key_Up
            }
            EditKey {
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                text: "❱❱"
                keyCode: Qt.Key_Right; mKey: Qt.ControlModifier
            }
            EditKey {
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                text: "◀"
                keyCode: Qt.Key_Left
            }
            BGButton {
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                id: btnSel
                font.pixelSize: 10
                text: "SEL"
                checkable: true
            }
            EditKey {
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                text: "▶"
                keyCode: Qt.Key_Right
            }
            EditKey {
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                text: "❙❰"
                keyCode: Qt.Key_Home
            }
            EditKey {
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                text: "▼"
                keyCode: Qt.Key_Down
            }
            EditKey {
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                text: "❱❙"; keyCode: Qt.Key_End
            }
        }
    }
    
    Component {
        id: mobileModKeys
        Flow {
            property alias btnSel: btnSel
            spacing: 0
            BGButton {
                id: btnSel
                font.pixelSize: 12
                text: "SEL"
                checkable: true
                height: 27
            }
            EditKey {
                text: "◀"
                keyCode: Qt.Key_Left
                font.pixelSize: 12
                width: 27
                height: 27
            }
            EditKey {
                text: "▲"
                keyCode: Qt.Key_Up
                font.pixelSize: 12
                width: 27
                height: 27
            }
            EditKey {
                text: "▼"
                keyCode: Qt.Key_Down
                font.pixelSize: 12
                width: 27
                height: 27
            }
            EditKey {
                text: "▶"
                keyCode: Qt.Key_Right
                font.pixelSize: 12
                width: 27
                height: 27
            }
        }
    }
    
    Loader {
        Layout.fillWidth: true
        Layout.leftMargin: 10
        sourceComponent: Screen.height >= 800 ? tabCharKeys : mobileCharKeys
    }
    Loader {
        Layout.rightMargin: 10
        sourceComponent: Screen.height >= 800 ? tabModKeys : mobileModKeys
        onLoaded: {
            isSel = Qt.binding (function () {
                return item.btnSel.checked;
            });
        }
    }
}
