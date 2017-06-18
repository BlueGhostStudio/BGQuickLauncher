import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import BGStudio 1.0
import BGQuickLauncher 1.0
import BGControls 1.0
/*
    MODEL:
        BGFile.fileModel: 文件model
            modelData.fileName: 文件名
            modelData.path: 路径
            modelData.isDir: true为目录, 否则为文件
            modelData.isFile: true为文件
            modelData.size: 文件大小
            modelData.created: 文件建立日期
        
        BGFile.modelDir: 设置model的目录
        BGFile.modelNameFilter: 过滤
        
    文件操作:
        BGFile.cp (s, t): 文件复制
        BGFile.mv (s, t): 文件移动/改名
        BGFile.rm (f): 删除文件
        BGFile.mkpath: 新建目录
        BGFile.rmpath: 删除目录
        BGFile.exist: 是否存在文件
        
    调用应用:
        {
            var appItem = fileManager.Launcher.launcher.newInstance ("应用名称")
            appItem....
        }
    
*/
ColumnLayout{
    id: fileView
    //property string dir: BGFile.standardLocations (BGFile.Documents)[0]
    property string area
    property alias dir: dirModel.dir
    property bool showSize: true
    property bool showDatetime: true
    property var selectedFiles: []
    property bool showPathSelector: true
    
    signal fileClicked (string path)
    signal fileSelected (string path)
    
    function clearSelect () {
        selectedFiles = []
    }
    
    spacing: 0
    BGArea {
        area: "banner"
        Layout.fillWidth: true
        height: 32
        visible: showPathSelector
 
        ListView {
            id: pathSelector
            width: parent.width
            model: fileView.dir.toString ().replace(/(^file:\/\/|\/$)/g, "").split ('/')
            orientation: ListView.Horizontal
            height: 32
            spacing: 5
            
            clip: true
            
            onContentWidthChanged: positionViewAtEnd ()

            delegate: MouseArea {
                height: 32
                width: rlPath.width
                RowLayout {
                    id: rlPath
                    anchors.centerIn: parent
                    spacing: 5
                    BGText {
                        id: txtPath
                        area: "banner"//fileView.area
                        text: modelData;
                        font.bold: index === pathSelector.count - 1
                    }
                    BGText {
                        area: "banner"//fileView.area
                        text: "/"
                        visible: index < pathSelector.count - 1
                    }
                }
                onClicked:  {
                    var path = "";
                    for (var i = 0; i <= index; i++) {
                        path += pathSelector.model[i] + '/';
                    }
                    fileView.dir = path;
                }
            }
        }
    }

    BGDirModel {
        id: dirModel
        dir: BGFile.standardLocations (BGFile.Documents)[0]
        filter: BGFile.NoDotAndDotDot | BGFile.AllEntries
        onDirChanged: fileView.selectedFiles = []
    }
    ListView{
        id: lst
        clip:true
        
        //model:BGFile.fileModel
        pixelAligned: true
        model: dirModel.fileList
        Layout.fillWidth: true
        Layout.fillHeight: true
        delegate: Rectangle {
            property bool selected: false
            id: fileDelegate
            width: lst.width
            height: 32
            color: selected ? BGCtrlStyle[fileView.area + "highlight"] : BGCtrlStyle[fileView.area + "bgColor"]
            //height: Math.floor (rowLayout.height+10)
            Component.onCompleted: {
                fileView.selectedFilesChanged.connect (function () {
                    if (fileView === undefined)
                        return;
                    var si = fileView.selectedFiles.indexOf (modelData.path);
                    if ((si >= 0 && !selected) || (si === -1 && selected)) {
                        selected = (si >= 0);
                        //requestPaint ();
                    }
                });
            }
            RowLayout {
                id: rowLayout
                width: parent.width - 10
                anchors.centerIn: parent
                Text{
                    id: txtFileName
                    Layout.fillWidth: true
                    text:modelData.fileName
                    elide: Text.ElideRight
                    color: selected ? BGColor.contrast (
                        BGCtrlStyle[fileView.area + "textColor"],
                        BGCtrlStyle[fileView.area + "highlight"], 1)
                            : BGCtrlStyle[area + "textColor"]
                }
                Text {
                    Layout.preferredWidth: 50
                    text: modelData.size
                    visible: !modelData.isDir && showSize
                    elide: Text.ElideRight
                    color: txtFileName.color
                }
                Text {
                    Layout.preferredWidth: 120
                    text: modelData.created
                    visible: !modelData.isDir && showDatetime
                    elide: Text.ElideRight
                    color: txtFileName.color
                }
            }
            MouseArea{
                anchors.fill:parent
                onClicked:{
                    if(modelData.isDir) {
                        fileView.dir =modelData.path
                    } else
                        fileView.fileClicked (modelData.path)
                }
                onPressAndHold: {
                    var si = fileView.selectedFiles.indexOf (modelData.path);
                    if (si === -1)
                        fileView.selectedFiles.push (modelData.path);
                    else
                        fileView.selectedFiles.splice (si, 1);

                    fileView.selectedFilesChanged ();
                }
            }
        }
    }
    /*Component.onCompleted: {
       BGFile.modelDir = Qt.binding (function () { return dir })
       BGFile.modelFilter = BGFile.NoDotAndDotDot | BGFile.AllEntries
    }*/
}