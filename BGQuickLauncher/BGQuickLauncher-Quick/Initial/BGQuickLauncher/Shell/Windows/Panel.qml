import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

Rectangle{
    property alias taskBar: taskBar
    width:parent.width
    height: rl.height+10
    color:'#778ea6'
    RowLayout {
        id: rl
        x:5
        y:5
        width:parent.width-10
        
        Image {
            Layout.preferredWidth:32
            Layout.preferredHeight:32
            source:'image/appIcon.png'
            MouseArea{
                anchors.fill:parent
                onClicked:appsMenu.open()
            }
        }
        TaskBar {
            id: taskBar
            Layout.fillWidth: true
        }
        DateWidget {}
    }
}
