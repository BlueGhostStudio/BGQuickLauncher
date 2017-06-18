import QtQuick 2.7

Flickable {
    id: flickablle
    
    property alias model: repeater.model
    default property alias delegate: repeater.delegate
    property alias flow: flow
    
    contentHeight: flow.height
    Flow {
        id: flow
        width: flickablle.width
        Repeater {
            id: repeater
        }
    }
}
