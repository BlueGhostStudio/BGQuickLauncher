import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import BGControls 1.0

BGArea {
    area: "banner"
    height: toolbarLayout.implicitHeight + 10
    //color: BGCtrlStyle.bannerbgColor
    ColumnLayout {
        id: toolbarLayout
        anchors.fill: parent
        anchors.margins: 5
        RowLayout {
            spacing: 0
            BGText {
                text: path.length > 0 ? path : "NewFile"
                elide: Text.ElideLeft
                Layout.fillWidth: true
            }
            BGText { text: edit.modified ? "*" : "" }
        }
        RowLayout {
            spacing: 0
            BGButton {
                text: "New"
                font.pixelSize: 12
                onClicked: edit.newFile ()
                    /*if (edit.modified)
                        messBox.question ("Modified", "Some file has Modified, save it?",
                            function () {
                                edit.actionAfterSave = function () {
                                    edit.newFile ();
                                }
                                edit.save ();
                            }, function () {
                                edit.newFile ();
                            });
                    else
                        edit.newFile ();
                }*/
            }
            BGButton {
                id: btnSave
                text: "Save"
                font.pixelSize: 12
                onClicked: {
                    edit.save ()
                    /*if (editRootItem.path.length > 0)
                        editRootItem.save ();
                    else
                        dlgFileName.open ();*/
                }
            }
            BGButton {
                text: "Save as"
                font.pixelSize: 12
                onClicked: {
                    edit.openFileDialog ();
                }
            }
            Item { Layout.fillWidth: true }
            BGButton {
                text: "Undo"
                font.pixelSize: 12
                visible: edit.edit.canUndo
                onClicked: edit.edit.undo ();
            }
            BGButton {
                text: "Redo"
                font.pixelSize: 12
                visible: edit.edit.canRedo
                onClicked: edit.edit.redo ();
            }
            BGButton {
                text: "Copy"
                font.pixelSize: 12
                visible: edit.edit.selectedText.length
                onClicked: edit.edit.copy ()
            }
            BGButton {
                text: "Cut"
                font.pixelSize: 12
                visible: edit.edit.selectedText.length
                onClicked: edit.edit.cut ()
            }
            BGButton {
                text: "Paste"
                font.pixelSize: 12
                visible: edit.edit.canPaste
                onClicked: edit.edit.paste ()
            }
        }
    }
}