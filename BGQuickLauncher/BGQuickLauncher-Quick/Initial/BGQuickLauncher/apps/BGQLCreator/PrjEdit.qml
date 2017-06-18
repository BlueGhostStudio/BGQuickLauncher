import QtQuick 2.7
import BGControls 1.0
import QtQuick.Layouts 1.3
import BGStudio 1.0
import QtQuick.Controls 2.0
import QtQuick.Window 2.2

ColumnLayout {
    id: editRootItem
    property var open: edit.open
    readonly property alias path: edit.path
    spacing: 0
    
    RowLayout {
        Layout.fillWidth: true
        Layout.margins: 5
        spacing: 0
        BGButton {
            iconSize: Screen.height >= 800 ? 32 : 22
            icon: BGIcons.icon("save", color)
            onClicked: edit.save ()
        }
        BGButton {
            iconSize: Screen.height >= 800 ? 32 : 22
            icon: BGIcons.icon("saveAs", color)
            onClicked: edit.openFileDialog ()
        }
        BGButton {
            iconSize: Screen.height >= 800 ? 32 : 22
            icon: BGIcons.icon ("copy", color);
            onClicked: edit.edit.copy ();
        }
        BGButton {
            iconSize: Screen.height >= 800 ? 32 : 22
            icon: BGIcons.icon ("cut", color);
            onClicked: edit.edit.cut ();
        }
        BGButton {
            iconSize: Screen.height >= 800 ? 32 : 22
            icon: BGIcons.icon ("paste", color);
            onClicked: edit.edit.paste ();
        }
        BGButton {
            iconSize: Screen.height >= 800 ? 32 : 22
            icon: BGIcons.icon ("undo", color);
            onClicked: edit.edit.undo ();
        }
        BGButton {
            iconSize: Screen.height >= 800 ? 32 : 22
            icon: BGIcons.icon ("redo", color);
            onClicked: edit.edit.redo ();
        }
        Item { Layout.fillWidth: true }
        BGButton {
            text: "KEY"
            onClicked: extKeyBoard.visible = !extKeyBoard.visible
            font.pixelSize: Screen.height >= 800 ? 22 : 16
        }
    }
    BGSynHLEdit {
        id: edit
        clip: true
        Layout.fillWidth: true
        Layout.fillHeight: true
        dir: prjFiles.dir
        fontSize: 10
        onSavedAs: {
            var index = editIndex (path);
            resetTabBar (index, fileName (path), path);
        }
        onModifiedChanged: {
            if (opened) {
                var index = editIndex (path);
                var fn = fileName (path);
                if (modified) fn += "*";
                resetTabBar (index, fn, path);
            }
        }
        onEditFocusChanged: {
            focusEdit = edit;
        }
    }
    ExtendKeyBoard {
        id: extKeyBoard
        visible: false
        Layout.fillWidth: true
    }
}
