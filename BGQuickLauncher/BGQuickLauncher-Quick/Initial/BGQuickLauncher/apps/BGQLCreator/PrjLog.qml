import QtQuick 2.7
import QtQuick.Layouts 1.3
import BGControls 1.0
import BGStudio 1.0

// logDebug logWarning logInfo logCritical logFatal

ColumnLayout {
    spacing: 0
    
    BGTabBar {
        id: logTabBar
        Layout.fillWidth: true
        bgColor: BGCtrlStyle.bannerbgColor
        font.pixelSize: 20
        font.bold: true
        model: ["Debug", "Warning", "Info", "Critical", "Fatal"]
        implicitHeight: 42
        
        leftCtrl: BGText {
            area: "banner"
            text: "Log"
            width: implicitWidth + 10
            horizontalAlignment: Text.AlignRight
            font.pixelSize: 22
            font.bold: true
        }
        rightCtrl: BGButton {
            area: "banner"
            icon: BGIcons.icon ("broom", BGCtrlStyle.bannerbtnColor);
            onClicked: BGLauncherLog.clear ()
        }
    }
    StackLayout {
        id: runArea
        Layout.fillWidth: true
        Layout.fillHeight: true
        currentIndex: logTabBar.currentIndex
        Flickable {
            contentHeight: txtDebug.height
            clip: true
            BGText {
                id: txtDebug
                text: BGLauncherLog.logDebug
                wrapMode: Text.Wrap
                width: parent.width
            }
        }
        Flickable {
            contentHeight: txtWarning.height
            clip: true
            BGText {
                id: txtWarning
                text: BGLauncherLog.logWarning
                wrapMode: Text.Wrap
                width: parent.width
            }
        }
        Flickable {
            contentHeight: txtInfo.height
            clip: true
            BGText {
                id: txtInfo
                text: BGLauncherLog.logInfo
                wrapMode: Text.Wrap
                width: parent.width
            }
        }
        Flickable {
            contentHeight: txtCritical.height
            clip: true
            BGText {
                id: txtCritical
                text: BGLauncherLog.logCritical
                wrapMode: Text.Wrap
                width: parent.width
            }
        }
        Flickable {
            contentHeight: txtFatal.height
            clip: true
            BGText {
                id: txtFatal
                text: BGLauncherLog.logFatal
                wrapMode: Text.Wrap
                width: parent.width
            }
        }
    }
}
