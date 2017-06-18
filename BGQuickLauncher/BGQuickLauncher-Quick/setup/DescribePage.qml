import QtQuick 2.7

Rectangle {
    DescribeData { id: data }
    color: "black"
    
    Component {
        id: setupPage
        SetupPage {}
    }
    
    Item {
        anchors.fill: parent
        anchors.margins: 25
        
        Text {
            id: txt0
            width: parent.width
            color: "white"
            text: data.about
            font.pixelSize: 32
            wrapMode: Text.Wrap
            opacity: 0
        }
        Text {
            id: txtNext0
            text: "NEXT…"
            y: txt0.height + 50
            color: "blue"
            opacity: 0
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    ani1.start ()
                }
            }
        }
        Text {
            id: txt1
            width: parent.width
            color: "white"
            text: data.develop.desc
            font.pixelSize: 32
            wrapMode: Text.Wrap
            opacity: 0
        }
        Item {
            id: item0
            y: txt1.height + 50
            property bool aniRunning: false
            width: parent.width
            height: childrenRect.height
            Repeater {
                model: data.develop.fav
                Text {
                    id: txtLi
                    text: modelData
                    font.pixelSize: 22
                    color: "white"
                    y: index * font.pixelSize + 50
                    width: parent.width
                    wrapMode: Text.Wrap
                    opacity: 0
                    SequentialAnimation {
                        running: item0.aniRunning
                        PauseAnimation {
                            duration: 250 * index
                        }
                        ParallelAnimation {
                            NumberAnimation {
                                target: txtLi
                                property: "y"
                                to: index * (font.pixelSize + 10)
                                duration: 500
                                easing.type: Easing.InOutBack
                            }
                            NumberAnimation {
                                target: txtLi
                                property: "opacity"
                                to: 1
                                duration: 500
                            }
                        }
                    }
                }
            }
        }
        Text {
            id: txtNext1
            text: "NEXT…"
            y: item0.y + item0.height + 50
            color: "blue"
            opacity: 0
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    mainStackView.push (setupPage);
                }
            }
        }
    }
    SequentialAnimation {
        id: ani0
        running: true
        ParallelAnimation {
            NumberAnimation {
                target: txt0
                property: "opacity"
                duration: 1000
                to: 1
            }
            NumberAnimation {
                target: txt0
                property: "y"
                duration: 1000
                from: 10
                to: 0
            }
        }
        PauseAnimation { duration: 500 }
        NumberAnimation {
            target: txtNext0
            property: "opacity"
            duration: 1000
            to: 1
        }
    }
    SequentialAnimation {
        id: ani1
        ParallelAnimation {
            NumberAnimation {
                targets: [txt0, txtNext0]
                property: "opacity"
                duration: 1000
                to: 0
            }
            NumberAnimation {
                target: txt1
                property: "opacity"
                duration: 1000
                to: 1
            }
            NumberAnimation {
                target: txt1
                property: "y"
                duration: 1000
                from: 10
                to: 0
            }
            SequentialAnimation {
                PauseAnimation { duration: 500 }
                ScriptAction {
                    script: item0.aniRunning = true
                }
            }
        }
        ScriptAction {
            script: {
                txt0.visible = false;
                txtNext0.visible = false;
            }
        }
        PauseAnimation { duration: 500 }
        NumberAnimation {
            target: txtNext1
            property: "opacity"
            duration: 1000
            to: 1
        }
    }
}
