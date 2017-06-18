import QtQuick 2.7
import QtQuick.Layouts 1.3

Flickable {
    property int currentInstance: -1
    signal instanceActived (int iid)
    signal instanceMaxWindow (int iid)
    implicitHeight: row.height
    contentWidth: row.width
    clip: true
    Row {
        id: row
        spacing: 2
        Repeater {
            model: launcher.instanceList
            Rectangle{
                clip:true
                color: modelData.id === currentInstance ? '#00f' : '#aaa'
                width:100
                height:32   //parent.height
                MouseArea {
                    anchors.fill: parent
                    onClicked: instanceActived (modelData.id)
                    onPressAndHold: instanceMaxWindow (modelData.id)
                }
                Text {
                    anchors.centerIn: parent
                    text: modelData.appInfo.title
                    color: "white"
                }
            }
        }
    }
}