import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import BGCanvas 1.0
import QtGraphicalEffects 1.0

Item {
    id: rootItem
    property alias viewport: viewport
    property alias title: txtTitle.text
    property bool actived: true
    property int iid
    property int winX:0
    property int winY:0
    property int winWidth: 300
    property int winHeight: 300
    property bool maxWin: false
    property bool minWin: false
    objectName: "InstanceWindow"
    
    visible: !minWin
    
    signal activeWindow ()
    
    function maxRestore () {
        if (!maxWin) {
            rootItem.width=appWin.contentItem.width
            rootItem.height=appWin.contentItem.height
            rootItem.x=0
            rootItem.y=0
            maxWin = true
        } else {
            rootItem.width = Qt.binding (function () { return winWidth });
            rootItem.height = Qt.binding (function () { return winHeight });
            maxWin = false;
            rootItem.x=Qt.binding (function () { return winX });
            rootItem.y=Qt.binding (function () { return winY });
        }
    }
    
    Rectangle {
        anchors.fill: parent
        anchors.margins: maxWin ? 0 : 5
        color: "#ccc"
        
        layer.enabled: !maxWin
        layer.effect: DropShadow {
            transparentBorder: true
            radius: 5
            samples: 11
            horizontalOffset: 0
            verticalOffset: 0
            color: "#90000000"
        }
    }
    
    width: winWidth
    height: winHeight
    x: winX
    y: winY
    /*border.color: "black"
    border.width: 1
    color: "gray"*/
    /*paintScript: function (p) {
        p.setBrush ("#ccc");
        p.setPenStyle (Qt.NoPen);
        if (!maxWin) {
            p.setShadowEnabled (true, "#60000000", 2);
            p.drawRoundRect (2, 2, width - 4, height - 4, 2);
        } else {
            p.setShadowEnabled (false);
            p.drawRound (0, 0, width, height);
        }
    }*/

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: maxWin ? 0 : 6
        spacing: 0
        
        Rectangle {
            id: rectTitle
            visible: !maxWin
            MouseArea{
                anchors.fill: parent
                onPositionChanged: {
                    if (!maxWin) {
                        winX += mouseX - clickX;
                        winY += mouseY - clickY;
                    }
                }
                onPressed: {
                    if (!maxWin) {
                        clickX=mouseX;
                        clickY=mouseY;
                    }
                    activeWindow ()
                }
                property real clickX
                property real clickY
            }
            
            color: actived ? "blue" : "gray"
            height: rlTitle.implicitHeight + 10
            Layout.fillWidth: true
            RowLayout {
                id: rlTitle
                anchors.fill: parent
                anchors.margins: 5
                Text {
                    id: txtTitle
                    Layout.fillWidth: true
                    color: "white"
                }
                Image {
                    source: "image/min.png"
                    MouseArea{
                        anchors.fill: parent
                        onClicked:{
                            minWin = true
                        }
                    }
                }
                Image {
                    source: "image/max.png"
                    MouseArea{
                        anchors.fill: parent
                        
                        onClicked: {
                            maxRestore ();
                        }
                    }
                }
                Image {
                    source: "image/close.png"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            launcher.instance (iid).close ();
                            rootItem.destroy ();
                        }
                    }
                }
            }
        }
        
        Item {
            id:viewport
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
        }
    }
    MouseArea{
        width:32
        height:32
        x:rootItem.width-width
        y:rootItem.height-height

        onPositionChanged: {
            if (!maxWin) {
                winWidth += mouseX - clickX;
                winHeight += mouseY - clickY;
            }
        }
        onPressed: {
            if (!maxWin) {
                clickX=mouseX;
                clickY=mouseY;
            }
            activeWindow ()
        }
        property real clickX
        property real clickY
    }
}
