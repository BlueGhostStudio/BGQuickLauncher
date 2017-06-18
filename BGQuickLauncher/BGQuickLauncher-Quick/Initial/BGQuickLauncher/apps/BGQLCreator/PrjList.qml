import QtQuick 2.7
import QtQuick.Layouts 1.3
import BGControls 1.0
import BGStudio 1.0
import QtQuick.Window 2.2

Flickable {
    property string path
    //property bool isApp: false
    property int type: 0
    
    clip: true
    function refresh () {
        repeater.model = [];
        repeater.model = dirModel.fileList;
    }
    BGDirModel {
        id: dirModel
        dir: path
        filter: BGFile.NoDotAndDotDot | BGFile.AllEntries
    }
    contentHeight: prjList.height
    Flow {
        id: prjList
        width: parent.width
        spacing: 0
        Repeater {
            id: repeater
            model: dirModel.fileList
            BGCardNew {
                id: prjCard
                property var prjInfo
                radius: 5
                shdRadius: 5
                width: Screen.height >= 800 ? prjList.width / 4 : prjList.width
                MouseArea {
                    implicitWidth: clPrj.width
                    implicitHeight: clPrj.height
                    ColumnLayout {
                        id: clPrj
                        width: parent.width
                        spacing: 0
                        BGText {
                            text: modelData.fileName
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }
                        BGText {
                            id: txtTitle
                            visible: type === 0
                            font.pixelSize: 22
                            font.bold: true
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }
                        BGText {
                            id: txtDesc
                            visible: type === 0
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }
                    }
                    onClicked: openProject (prjInfo)
                }
                Component.onCompleted: {
                    var p = {};
                    p.appName = modelData.fileName;
                    //p.isApp = isApp;
                    p.type = type;
                    p.rootDir = path + p.appName;
                    
                    if (type === 0) {
                        BGSettings.open (path + '/' + modelData.fileName + "/appProp");
                        txtTitle.text = BGSettings.value ("title");
                        txtDesc.text = BGSettings.value ("description");
                        p.iconSrc = BGSettings.value ("iconSrc");
                        
                        p.title = txtTitle.text;
                        p.description = txtDesc.text;
                    }
                    prjInfo = p;
                }
            }
        }
    }
}
