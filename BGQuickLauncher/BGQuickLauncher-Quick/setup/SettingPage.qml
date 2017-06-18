import QtQuick 2.7
import Qt.labs.settings 1.0
import QtQuick.Controls 2.0

Page {
    header: Rectangle {
        color: "#ccc"
        height: 48
        Text {
            anchors.centerIn: parent
            text: "Select Shell"
            font.pixelSize: 32
            font.bold: true
        }
    }
    Component {
        id: finishedPage
        FinishedPage {}
    }
    Settings {
        id: settings
        property var shell
    }
    
    ListView {
        width: 200
        height: 150
        x: (parent.width - width) / 2
        y: (parent.height - height) / 4
        model: ["Default", "BlueGhostDesktop"]
        delegate: ItemDelegate {
            text: modelData
            width: parent.width
            font.pixelSize: 22
            font.bold: true
            onClicked: {
                settings.shell = modelData;
                mainStackView.push (finishedPage);
            }
        }
    }   
}