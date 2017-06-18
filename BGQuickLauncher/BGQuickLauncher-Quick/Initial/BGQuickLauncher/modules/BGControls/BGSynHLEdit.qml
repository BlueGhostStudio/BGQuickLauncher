import QtQuick 2.7
import QtQuick.Layouts 1.3
import BGControls 1.0
import QtQuick.Controls 2.0
import BGStudio 1.0
import "private"

Item {
    id: rootItem
    property color bgColor: BGCtrlStyle.inputColor//"black"
    property color textColor: BGCtrlStyle.inputTextColor//ColorFun.invertColor (bgColor, 1)
    property color selectionColor: BGCtrlStyle.highlight
    property color selectedTextColor: BGColor.contrast (selectionColor, 0.5)
    property alias hlContrastFactor: tep.hlContrastFactor
    property alias text: textEdit.text
    property alias modified: tep.modified
    property alias edit: textEdit
    property alias fontSize: textEdit.font.pixelSize
    property alias editFocus: textEdit.focus
    
    property string path
    property url dir
    property var actionAfterSave: null
    property bool opened: false
    
    property alias fixedFont: fixedFont
    
    signal savedAs ()
    
    FontLoader { id: fixedFont; source: "Monaco.ttf" }
    
    function openFileDialog () {
        dlgFileName.open ();
    }
    function open (path) {
        if (edit.modified) {
            messBox.question ("Modified", "Some file has Modified, save it?",
                function () {
                    actionAfterSave = function () { open (path) };
                    save ();
                },
                function () {
                    edit.modified = false;
                    open (path);
                });
        } else {
            opened = false;
            rootItem.path = path
            rootItem.text = BGFile.readFile (path);
            rootItem.modified = false;
            actionAfterSave = null;
            opened = true;
        }
    }
    function save (saveAs) {
        if (path.length === 0) {
            dlgFileName.open ();
            return;
        }
        
        if (saveAs || rootItem.modified) {
            BGFile.writeFile (path, edit.text);
            rootItem.modified = false;
            opened = true;
            savedAs ();
        }
        if (actionAfterSave)
            actionAfterSave ();
    }
    function newFile () {
        if (rootItem.modified)
            messBox.question ("Modified", "Some file has Modified, save it?",
                function () {
                    rootItem.actionAfterSave = function () {
                        rootItem.newFile ();
                    }
                    rootItem.save ();
                }, function () {
                    rootItem.newFile ();
                });
        else {
            opened = false;
            rootItem.path = "";
            rootItem.text = "";
            rootItem.modified = false;
            rootItem.actionAfterSave = null;
            opened = true;
        }
    }
    
    BGMessageBox { id: messBox }
    BGDialog {
        id: dlgFileName
        title: "Save as"
        property string path: BGFile.urlToPath (rootItem.dir)//BGFile.urlToPath (editRootItem.path)
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
            rootItem.opened = false;
            rootItem.path = dlgFileName.path + '/' + leFileName.text;
            rootItem.save (true);
        }
    }
    
    
    
    Flickable {
        id: flickable
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick
        contentHeight: textEdit.contentHeight//textEdit.implicitHeight//Math.max (height, textEdit.height)
        
        function ensureVisible(r)
        {
           if (contentY >= r.y)
               contentY = r.y;
           else if (contentY+height <= r.y+r.height)
               contentY = r.y+r.height-height;
        }
       
        TextArea {
            id: textEdit
            width: flickable.width
            background: Rectangle { color: bgColor }
            leftPadding: 32
            font.family: fixedFont.name
            color: textColor
            selectionColor: rootItem.selectionColor
            selectedTextColor: rootItem.selectedTextColor
            //height: 1024
            implicitHeight: Math.max (flickable.height * 1.5, contentHeight)
            
            
            cursorDelegate: Rectangle {
                width: 2
                color: textColor
            }
            wrapMode: TextArea.Wrap
            padding: 0
            
            onCursorRectangleChanged: flickable.ensureVisible(cursorRectangle)
            //onFocusChanged: rootItem.focus = true
        }
        /*onFlickEnded: {
            if (
        }*/
    }
    LineNumber {
        bgColor:BGColor.contrast (rootItem.bgColor, 0.15) //Qt.darker (rootItem.bgColor, 1.2)//ColorFun.invertColor (rootItem.bgColor, 0.15)
        textColor: BGColor.contrast (bgColor, 0.15) //Qt.darker (rootItem.textColor, 1.2)//ColorFun.invertColor (bgColor, 0.15)
    }
  
    BGTextEditProcess {
        id: tep
        editControl: textEdit
        /*syntaxFile: appsPath + "testWindow/syntaxSample"*/
        hlBGColor: bgColor
        hlContrastFactor: 0.5
        highlighter: {
            "normal": "black",
            "keyword": "#78d7ec",
            "type": "#55ff55",
            "error": "#cccccc",
            "symbol": "#a6e22e",
            "comment": "#75715e",
            "string": "#e0a000",
            "number": "#ffcd22",
            "field": "#ff5555"
        }
    }
}