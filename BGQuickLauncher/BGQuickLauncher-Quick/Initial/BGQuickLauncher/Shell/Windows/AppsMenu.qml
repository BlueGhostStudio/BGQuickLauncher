import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

Drawer {
    LauncherData {
        id: launcherData
    }
    // model [0]
    RowLayout {
        anchors.fill: parent
        ListView{
            id: cateList
            Layout.fillWidth: true
            Layout.fillHeight: true
            model:launcherData.cateModel()
            delegate:Button{
                text:modelData
                width:parent.width
                onClicked:lsvw.model=launcherData.appModel(index)
            }
        }
        ListView{
            id:lsvw
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
    width: appWin.width * 0.66
}
