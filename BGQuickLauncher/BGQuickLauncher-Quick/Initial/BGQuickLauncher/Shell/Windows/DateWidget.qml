import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

Text {
    id: txt
    color:'#fff'
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            var d = new Date;
            txt.text = d.getHours () + ":" + d.getMinutes() + ":"+d.getSeconds()
        }
    }
}
