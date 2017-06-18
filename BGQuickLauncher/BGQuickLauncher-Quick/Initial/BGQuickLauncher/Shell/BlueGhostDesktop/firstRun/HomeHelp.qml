import QtQuick 2.7
import QtQuick.Controls 2.0

Popup {
    id: popHomeHelp
    background: Rectangle {
        color: "#90000000"
    }
    padding: 0
    width: parent.width
    height: parent.height
    //anchors.fill: parent
    
    Rectangle {
        id: finger
        width: 64
        height: 64
        color: "#60ffffff"
        radius: 32
        opacity: 0
    }
    Text {
        id: txt0
        color: "white"
        opacity: 0
    }
    
    SequentialAnimation {
        id: ani
        ScriptAction {
            script: {
                finger.y = (parent.height - finger.height) / 2
                txt0.text = "手指在左侧往右滑动\n打开应用/任务菜单"
                txt0.y = finger.y + finger.height + 10
                txt0.x = 0
            }
        }
        NumberAnimation {
            target: txt0
            property: "opacity"
            to: 1
        }
        SequentialAnimation {
            loops: 2
            ParallelAnimation {
                NumberAnimation {
                    target: finger
                    property: "opacity"
                    duration: 250
                    from: 0
                    to: 1
                }
                NumberAnimation {
                    target: finger
                    property: "x"
                    duration: 750
                    from: -finger.width / 2
                    to: 96
                }
            }
            ParallelAnimation {
                NumberAnimation {
                    target: finger
                    property: "opacity"
                    duration: 250
                    to: 0
                }
                NumberAnimation {
                    target: finger
                    property: "x"
                    duration: 250
                    to: 128
                }
            }
        }
        NumberAnimation {
            target: txt0
            property: "opacity"
            to: 0
        }
        
        ScriptAction {
            script: {
                txt0.text = "右侧往左滑动\n打开小部件区域"
                txt0.x = parent.width - txt0.width
            }
        }
        NumberAnimation {
            target: txt0
            property: "opacity"
            to: 1
        }
        SequentialAnimation {
            loops: 2
            ParallelAnimation {
                NumberAnimation {
                    target: finger
                    property: "opacity"
                    duration: 250
                    from: 0
                    to: 1
                }
                NumberAnimation {
                    target: finger
                    property: "x"
                    duration: 750
                    from: parent.width - finger.width / 2
                    to: parent.width - finger.width - 96
                }
            }
            ParallelAnimation {
                NumberAnimation {
                    target: finger
                    property: "opacity"
                    duration: 250
                    to: 0
                }
                NumberAnimation {
                    target: finger
                    property: "x"
                    duration: 250
                    to: parent.width - finger.width - 128
                }
            }
        }
        NumberAnimation {
            target: txt0
            property: "opacity"
            to: 0
        }
        ScriptAction {
            script: popHomeHelp.close ();
        }
    }
    
    function start () {
        open ();
        ani.start ();
    }
}