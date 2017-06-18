import QtQuick 2.7

Rectangle {
    id: root
    Component {
        id: describePage
        DescribePage {}
    }
    property real logoWidth: (txt0.width + txt2.width
        + txt4.width) * 0.5 + txt5.width
    property int fontSize: 64
    color: "black"
    Item {
        id: wrap1
        width: logoWidth
        height: txt0.height / 2
        x: (parent.width - width) / 2
        y: (parent.height - height) / 3
        opacity: 0
        Item {
            id: wrap2
            transformOrigin: Item.Left
            width: logoWidth - txt5.width
            height: txt0.height
            y: (parent.height - height) / 2
            //color: "blue"
            Text {
                id: txt0
                text: "B"
                font.pixelSize: fontSize
                font.bold: true
                color: "blue"
            }
            Text {
                id: txt1
                x: txt0.x + txt0.width
                anchors.baseline: txt0.baseline
                text: "lue"
                font.pixelSize: fontSize * 0.75
                color: "white"
            }
            Text {
                id: txt2
                //anchors.left: txt1.right
                x: txt1.x + txt1.width
                anchors.baseline: txt1.baseline
                text: "G"
                font.pixelSize: fontSize
                font.bold: true
                color: "blue"
            }
            Text {
                id: txt3
                x: txt2.x + txt2.width
                anchors.baseline: txt2.baseline
                text: "host"
                font.pixelSize: fontSize * 0.75
                color: "white"
            }
            Text {
                id: txt4
                anchors.baseline: txt3.baseline
                color: "#99cc66"
                text: "Quick"
                font.pixelSize: fontSize
                x: txt0.x + txt0.width + txt2.width
                opacity: 0
            }
        }
        Text {
            id: txt5
            //anchors.baseline: txt4.baseline
            //x: txt0.x + txt0.width + txt2.width + txt4.width
            x: wrap2.width
            color: "white"
            font.pixelSize: 32
            text: "Launcher"
            opacity: 0
        }
    }
    SequentialAnimation {
        id: ani
        //running: true
        NumberAnimation {
            target: wrap1
            property: "opacity"
            duration: 1000
            to: 1
        }
        PauseAnimation { duration: 500 }
        ParallelAnimation {
            NumberAnimation {
                target: txt1
                property: "opacity"
                duration: 250
                to: 0
            }
            NumberAnimation {
                target: txt3
                property: "opacity"
                duration: 250
                to: 0
            }
            NumberAnimation {
                target: txt2
                property: "x"
                duration: 250
                to: txt0.x + txt0.width
            }
            NumberAnimation {
                target: txt4
                property: "opacity"
                duration: 250
                to: 1
            }
        }
        //PauseAnimation { duration: 500 }
        ParallelAnimation {
            NumberAnimation {
                target: wrap2
                property: "scale"
                duration: 250
                to: 0.5
            }
            NumberAnimation {
                target: txt5
                property: "opacity"
                duration: 2000
                to: 1
            }
        }
        PauseAnimation { duration: 500 }
        ParallelAnimation {
            NumberAnimation {
                target: wrap1
                property: "opacity"
                duration: 1000
                to: 0
            }
            /*NumberAnimation {
                target: wrap1
                property: "y"
                duration: 1000
                to: (parent.height - height) / 3 - 50
            }*/
        }
        ScriptAction {
            script: mainStackView.push (describePage);
        }
    }
    onWidthChanged: {
        ani.start ()
    }
}