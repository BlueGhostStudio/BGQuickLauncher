import QtQuick 2.7
import BGControls 1.0
import QtQuick.Layouts 1.3
import BGStudio 1.0
import QtQuick.Controls 2.0

ColumnLayout {
    spacing: 0
    property var openedFiles: []
    property Item focusEdit: null
    Component {
        id: editCmp
        PrjEdit {}
    }
    function fileName (file) {
        return /[^\/]*$/.exec(file)[0];
    }
    function openFile (file) {
        var index = editIndex (file);
        if (index >= 0)
            editTabBar.currentIndex = index;
        else {
            openedFiles.push ({
                d: fileName (file),
                v: file
            });
            var edit = editCmp.createObject (slEditArea);
            openedFilesChanged ();
            editTabBar.currentIndex = openedFiles.length - 1;
            edit.open (file);
        }
    }
    function resetTabBar (index, label, file) {
        slEditArea.currentIndex = index;
        
        openedFiles[index].d = label;
        if (file !== undefined)
            openedFiles[index].v = file;
        
        openedFilesChanged ();
        editTabBar.currentIndex = index;
        slEditArea.currentIndex = Qt.binding (function () {
            return editTabBar.currentIndex;
        });
    }
    function editIndex (file) {
        var children = slEditArea.children;
        for (var i in children) {
            if (children[i].path === file)
                return i;
        }
        
        return -1;
    }
    BGTabBar {
        id: editTabBar
        Layout.fillWidth: true
        bgColor: BGCtrlStyle.bannerbgColor
        model: openedFiles
        displayField: "d"
        valueField: "v"
        font.pixelSize: 20
        font.bold: true
        implicitHeight: 42
        leftCtrl: BGText {
            area: "banner"
            text: "Edit"
            width: implicitWidth + 10
            horizontalAlignment: Text.AlignRight
            font.pixelSize: 22
            font.bold: true
        }
        rightCtrl: BGButton {
            area: "banner"
            icon: BGIcons.icon ("close", BGCtrlStyle.bannerbtnColor);
            visible: openedFiles.length > 0
            onClicked: {
                var index = editTabBar.currentIndex;
                slEditArea.children[index].destroy ();
                
                openedFiles.splice (editTabBar.currentIndex, 1);
                openedFilesChanged ();
                
                
                var count = openedFiles.length
                if (index == count)
                    editTabBar.currentIndex = index - 1;
                else if (count > 0)
                    editTabBar.currentIndex = index;
                else
                    editTabBar.currentIndex = -1;
            }
        }
    }
    StackLayout {
        id: slEditArea
        currentIndex: editTabBar.currentIndex
        Layout.fillWidth: true
        Layout.fillHeight: true
        onCurrentIndexChanged: {
            if (focusEdit) {
                focusEdit.editFocus = false;
            }
        }
    }
}