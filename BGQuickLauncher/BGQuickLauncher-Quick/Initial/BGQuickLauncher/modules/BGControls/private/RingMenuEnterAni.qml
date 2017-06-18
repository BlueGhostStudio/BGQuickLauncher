import QtQuick 2.7

SequentialAnimation {
    id: seqAni
    property Item target
    property int index
    PauseAnimation { duration: index * (80 / repeater.count) }
    NumberAnimation {
        target: seqAni.target; properties: "scale"; from: 0;
        to: 1;
        duration: 120
    }
}