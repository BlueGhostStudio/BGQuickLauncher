import QtQuick 2.7
import BGControls 1.0
import BGStudio 1.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Flickable {
    height:rlPathSelector.height
    contentWidth: rlPathSelector.width
    RowLayout {
        id: rlPathSelector
        spacing: 0
        BGText {
            text: "ProjectRoot/"
                font.pixelSize: 22
                font.bold: true
            MouseArea {
                anchors.fill: parent
                onClicked: fvPrjFiles.dir = rootDir
            }
        }
        Repeater {
            id: repeater
            model: BGFile.urlToPath(fvPrjFiles.dir)
                .replace(rootDir, "")
                .replace(/^\//, '').split('/')
            BGText {
                id: pathSelector
                area: "banner"
                text: modelData
                    + (index < repeater.model.length - 1 ? '/' : '')
                font.pixelSize: 22
                font.bold: true
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var path = rootDir
                        for (var i = 0; i <= index; i++) {
                            path += '/' + repeater.model[i];
                        }
                        //console.log (path)
                        fvPrjFiles.dir = path;
                    }
                }
            }
        }
    }
}