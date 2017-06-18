import QtQuick 2.7
import QtQuick.Layouts 1.3
import BGControls 1.0
import QtQuick.Controls 2.0
import BGStudio 1.0
import BGQuickLauncher 1.0

SwipeView {
    id: editRootItem
    property alias path: edit.path
    //property var actionAfterSave: null
    background: Rectangle { color: BGCtrlStyle.bgColor }
    function setAppTitle () {
        Launcher.title = /[^\/]*$/.exec (path)[0];
        Launcher.launcher.instanceListChanged ();
    }
    onPathChanged: setAppTitle ()
    function open (path) {
        edit.open (path);
        currentIndex = 1;
    }
    /*function open (path) {
        if (edit.modified) {
            messBox.question ("Modified", "Some file has Modified, save it?",
                function () {
                    actionAfterSave = function () { open (path) };
                    btnSave.clicked ();
                },
                function () {
                    edit.modified = false;
                    open (path);
                });
        } else {
            editRootItem.path = path
            edit.text = BGFile.readFile (path);
            edit.modified = false;
            currentIndex = 1;
            actionAfterSave = null;
            Launcher.title = /[^\/]*$/.exec (path)[0];
            Launcher.launcher.instanceListChanged ();
        }
    }
    function save (saveAs) {
        if (saveAs || edit.modified) {
            BGFile.writeFile (path, edit.text);
            edit.modified = false;
        }
        if (actionAfterSave)
            actionAfterSave ();
    }
    function newFile () {
        editRootItem.path = "";
        edit.text = "";
        edit.modified = false;
        actionAfterSave = null;
    }
    BGMessageBox { id: messBox }
    BGDialog {
        id: dlgFileName
        title: "Save as"
        property string path: BGFile.urlToPath (fileView.dir)
        BGFieldLayout {
            BGField {
                label: "Path"
                BGText {
                    Layout.preferredWidth: Math.min (implicitWidth, 200);
                    text: dlgFileName.path
                    elide: Text.ElideLeft
                }
            }
            BGField {
                label: "File Name"
                BGLineEdit {
                    id: leFileName
                }
            }
        }
        
        onAccepted: {
            editRootItem.path = dlgFileName.path + '/' + leFileName.text;
            editRootItem.save (true);
        }
    }*/
    BGFileView {
        id: fileView
        showDatetime: false
        onFileClicked: {
            edit.open (path);
            currentIndex = 1;
        }
    }
    BGPage {
        header: Toolbar {}
        BGSynHLEdit {
            id: edit; clip: true
            dir: fileView.dir
            anchors.fill: parent
            hlContrastFactor: 0.6
            fontSize: 10
            //edit.selectByMouse: true
        }
    }
}