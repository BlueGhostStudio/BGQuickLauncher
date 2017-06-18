import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import BGQuickLauncher 1.0
import BGControls 1.0
import BGStudio 1.0

Rectangle {
    color: BGCtrlStyle.bgColor
    /*
     * BGCmd.exec (...) 调用系统命令, 参数为命令文本
     *    例如 BGCmd.exec ("cp a b") 执行命令cp a b
     * 文件相关命令
     *    cp: 复制
     *    mv: 移动/改名
     *    rm: 删除文件
     *    mkdir: 新建目录
     *    rmdir: 删除目录
     * leftFileView.selectedFiles: 一个数组, 保存选择的文件
     *    var selectedFiles = leftFileView.selectedFiles
     *    for (var i = 0; i < selectedFiles.length; i++) {
     *        var path = selectedFiles[i];
     *    }
     * swipeView.currentIndex: 0为第一页, 1为第二页, ...
     * FileView.clearSelect () 清楚选择
     * FileView.dir: 文件列表当前的目录
     */
    BGDialog {
        id: renameDlg
        property string fileName
        
        title: "Rename"
        
        BGFieldLayout {
            BGField {
                label: "new name"
                BGLineEdit {
                    id: leFileName
                    text: renameDlg.fileName
                }
            }
        }
        onOpened: leFileName.text = /[^\/]*$/.exec (fileName)[0]
        onAccepted: {
            var newFile = renameDlg.fileName.replace(/[^\/]*$/, leFileName.text);
            BGCmd.exec ("mv " + renameDlg.fileName + ' ' + newFile);
            renameDlg.close ();
        }
    }
    BGDialog {
        id: newFolderDlg
        
        title: "mkdir"
        BGFieldLayout {
            id: fieldLayout
            BGField {
                label: "Dir Name"
                BGLineEdit {
                    id: leFolderName
                }
            }
        }
        onOpened: leFolderName.text = newFolderDlg.height //""
        onAccepted: {
            var source = currentFileView ();
            if (leFolderName.text.length > 0)
                BGCmd.exec ("mkdir " + BGFile.urlToPath (source.dir) + '/' + leFolderName.text);
            //BGCmd.exec ("mkdir "+)
        }
    }
    BGDialog {
        id: newFileDlg
        
        title: "New File"
        BGFieldLayout {
            BGField {
                label: "File Name"
                BGLineEdit {
                    id: leNewFileName
                }
            }
        }
        onOpened: leNewFileName.text = ""
        onAccepted: {
            var source = currentFileView ();
            if (leNewFileName.text.length > 0)
                BGFile.writeFile (source.dir + '/' + leNewFileName.text, "");
        }
    }
    function iconStyle () {
        var c = BGCtrlStyle.bannerbtnColor;
        return Math.max (c.r, c.g, c.b) > 0.5 ? "" : "_dark";
    }
    function currentFileView () {
        return swipeView.currentIndex === 0 ? leftFileView : rightFileView;
    }
    function move (source, target) {
        var selectedFiles = source.selectedFiles;
        var targetPath = BGFile.urlToPath (target.dir);
        for (var i = 0; i < selectedFiles.length; i++) {
             var path = selectedFiles[i];
             BGCmd.exec ('mv ' + path+' ' + targetPath);
         }
         source.clearSelect ();
    }
    function copy (source, target) {
        var selectedFiles = source.selectedFiles;
        var targetPath = BGFile.urlToPath (target.dir);
        for (var i = 0; i < selectedFiles.length; i++) {
             var path = selectedFiles[i];
             BGCmd.exec ('cp -r '+path+' ' + targetPath);
         }
         source.clearSelect ();
    }
    function rename () {
        var source = currentFileView ();
        if (source.selectedFiles.length > 0) {
            var selectedFile = source.selectedFiles[0];
            renameDlg.fileName = selectedFile;
            renameDlg.open ();
        }
    }
    
    function open (path) {
        var editorInst = Launcher.launcher.newInstance ("editor");
        editorInst.open (path);
    }
        
    ColumnLayout {
        id: fileManager
        anchors.fill: parent
        spacing: 0
        RowLayout {
            spacing: 0
            BGArea {
                area: "banner"
                Layout.fillWidth: true
                height: 32
                opacity: swipeView.currentIndex === 0 ? 1 : 0.75
                BGText {
                    anchors.centerIn: parent;
                    horizontalAlignment: Text.AlignRight
                    text: /[^\/]*$/.exec (leftFileView.dir.toString ().replace(/\/$/, ""))[0]
                    //text: leftFileView.dir.toString ().replace(/\/$/, "");
                    //color: BGColor.contrast (parent.color, 0.5)
                    font.bold: true
                    elide: Text.ElideRight
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: swipeView.currentIndex = 0
                }
            }
            BGArea {
                area: "banner"
                Layout.fillWidth: true
                height: 32
                opacity: swipeView.currentIndex === 1 ? 1 : 0.75
                BGText {
                    anchors.centerIn: parent;
                    text: /[^\/]*$/.exec (rightFileView.dir.toString ().replace(/\/$/, ""))[0]
                    //color: BGColor.contrast (parent.color, 0.5)
                    font.bold: true
                    elide: Text.ElideRight
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: swipeView.currentIndex = 1
                }
            }
        }
        BGArea {
            area: "banner"
            Layout.fillWidth: true
            height: 40
            RowLayout {
                spacing: 0
                width: parent.width
                anchors.centerIn: parent
                BGButton {
                    icon: "copyLeftToRight" + iconStyle () + ".png"
                    onClicked:{
                        copy (leftFileView, rightFileView);
                    }
                }
                BGButton {
                    icon:"moveLeftToRight" + iconStyle () + ".png"
                    onClicked:{
                        move (leftFileView, rightFileView)
                        leftFileView.clearSelect ();
                    }
                }
            
                Item { Layout.fillWidth: true }
                
                BGButton {
                    icon: "newFolder" + iconStyle () + ".png"
                    onClicked: newFolderDlg.open ();
                }
                BGButton {
                    icon: "newFile" + iconStyle () + ".png"
                    onClicked: newFileDlg.open ();
                }
                BGButton {
                    icon: "rename" + iconStyle () + ".png"
                    onClicked: rename ()
                }
                BGButton {
                    icon: "remove" + iconStyle () + ".png"
                    onClicked: {
                        var view = currentFileView  ();
                        var selectedFiles = view.selectedFiles;
                        for (var i in selectedFiles)
                            BGCmd.exec ("rm -rf " + selectedFiles[i]);
                    }
                }
                BGButton {
                    icon: "unselect" + iconStyle () + ".png"
                    onClicked: {
                        swipeView.currentIndex === 0
                            ? leftFileView.clearSelect ()
                            : rightFileView.clearSelect ()
                    }
                }
            
                Item { Layout.fillWidth: true }
                
                BGButton {
                    icon: "moveRightToLeft" + iconStyle () + ".png"
                    onClicked:{
                        move (rightFileView, leftFileView);
                        leftFileView.clearSelect ();
                    }
                }
                BGButton {
                    icon: "copyRightToLeft" + iconStyle () + ".png"
                    onClicked:{
                        copy (rightFileView, leftFileView);
                    }
                }
            }
        }
        Rectangle {
            height: 1
            Layout.fillWidth: true
            color: BGCtrlStyle.bannertextColor
        }
        SwipeView {
            id: swipeView
            Layout.fillWidth: true
            Layout.fillHeight: true
            BGFileView {
                id: leftFileView
                Layout.fillWidth: true
                Layout.fillHeight: true
                showSize: false
                onFileClicked: open (path)
            }
            BGFileView {
                id: rightFileView
                Layout.fillWidth: true
                Layout.fillHeight: true
                onFileClicked: open (path)
            }
        }
    }
}