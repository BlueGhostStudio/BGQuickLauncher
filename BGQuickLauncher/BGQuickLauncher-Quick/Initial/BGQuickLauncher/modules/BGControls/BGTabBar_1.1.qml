import QtQuick 2.7
import BGCanvas 1.0
import BGControls 1.0
import QtQuick.Layouts 1.3

BGCanvas {
    id: tabBar
    property font font
    font.pixelSize: 16
    
    property color color: BGCtrlStyle.bgColor
    property color bgColor: Qt.darker (color, 1.5)
    property alias currentIndex: lvTabBar.currentIndex
    property int tabPadding: 5
    property int tabRadius: tabPadding
    
    property Item leftCtrl: null
    property Item rightCtrl: null
    
    property alias model: lvTabBar.model
    property string displayField
    property string valueField
    readonly property var value: valueField.length > 0
        ? model[currentIndex][valueField] : currentIndex
    
    height: rlTabBar.height
    
    RowLayout {
        id: rlTabBar
        width: parent.width
        anchors.bottom: parent.bottom
        Item {
            id: leftCtrlWrap
        }
        ListView {
            id: lvTabBar
            Layout.fillWidth: true
            height: font.pixelSize + tabPadding * 2 + 10//contentItem.childrenRect.height
            orientation: ListView.Horizontal
            Layout.alignment: Qt.AlignBottom
            delegate: BGTabButton {
                actived: ListView.isCurrentItem
            }
            onCurrentIndexChanged: {
                positionViewAtIndex (currentIndex,
                    ListView.Beginning);
            }
        }
        Item {
            id: rightCtrlWrap
        }
    }
    paths: [
        BGRect {
            x: 0
            y: 0
            width: tabBar.width
            height: tabBar.height
            fillColor: tabBar.bgColor
        },
        BGRect {
            x: 0
            y: tabBar.height - 2
            width: tabBar.width
            height: 1
            fillColor: "#90000000"
        },
        BGRect {
            x: 0
            y: tabBar.height - 1
            width: tabBar.width
            height: 1
            fillColor: "#c0ffffff"
        }
    ]
    Component.onCompleted: {
        if (leftCtrl) {
            leftCtrl.parent = leftCtrlWrap;
            leftCtrlWrap.implicitWidth = leftCtrl.width;
            leftCtrlWrap.implicitHeight = leftCtrl.height;
        }
        if (rightCtrl) {
            rightCtrl.parent = rightCtrlWrap;
            rightCtrlWrap.implicitWidth = rightCtrl.width;
            rightCtrlWrap.implicitHeight = rightCtrl.height;
        }
    }
}
