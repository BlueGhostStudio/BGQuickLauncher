import QtQuick 2.7
import QtQuick.Layouts 1.3
import BGControls 1.0

Canvas {
    id: tabBar
    property color color: BGCtrlStyle.bgColor
    property color bgColor: Qt.darker (color, 1.5)
    property real shadowRadius: 5
    property int tabPadding: 5
    property int tabRadius: 5
    property font font
    property alias currentIndex: lvTabs.currentIndex
    property alias model: lvTabs.model
    property Item leftCtrl: null
    property Item rightCtrl: null
    
    property string displayField
    property string valueField
    readonly property var value: valueField.length > 0
        ? model[currentIndex][valueField] : currentIndex
    
    contextType: "2d"
    
    onPaint: {
        var ctx = getContext ("2d");
        ctx.reset ();
        ctx.save ();
        ctx.fillStyle = bgColor;//Qt.darker (color, 1.5);
        ctx.fillRect (0, 0, width, height);
        
        ctx.fillStyle = color;
        ctx.shadowBlur = shadowRadius;
        ctx.shadowColor = "#60000000";
        ctx.fillRect (0, height, width, 5);
        
        ctx.restore ();
        ctx.fillStyle = "#60ffffff";
        ctx.fillRect (0, height - 1, width, 1);
    }
    
    implicitHeight: rowLayout.height
    onHeightChanged: requestPaint ()
    RowLayout {
        id: rowLayout
        width: parent.width
        anchors.bottom: parent.bottom
        Item {
            id: leftCtrlWrap
            //Layout.bottomMargin: 5
        }
        ListView {
            id: lvTabs
            Layout.bottomMargin: -2
            Layout.alignment: Qt.AlignBottom
            implicitHeight: contentItem.childrenRect.height
            Layout.fillWidth: true
            orientation: ListView.Horizontal
            clip: true
            snapMode: ListView.SnapToItem
            delegate: BGTabButton {}
            
            onCurrentIndexChanged: {
                positionViewAtIndex (currentIndex,
                    ListView.Beginning);
            }
        }
        Item {
            id: rightCtrlWrap
            //Layout.bottomMargin: 5
        }
    }
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
