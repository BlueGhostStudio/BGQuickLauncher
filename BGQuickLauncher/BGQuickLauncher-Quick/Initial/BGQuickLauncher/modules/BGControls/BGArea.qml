import QtQuick 2.7
import BGControls 1.0

Rectangle {
    id: areaRoot
    property string area: ""
    
    color: BGCtrlStyle[area + "bgColor"]
    
    function recursion (item) {
        var ch = item.children
        for (var i in ch) {
            if (ch[i].area !== undefined)
                ch[i].area = areaRoot.area
            recursion (ch[i])
        }
    }
    onAreaChanged: recursion (areaRoot)
    Component.onCompleted: {
        recursion (areaRoot)
    }
}
