import QtQuick 2.7
import QtQuick.Layouts 1.3
import BGControls 1.0
import BGStudio 1.0

BGPage {
    BGArea {
        anchors.fill: parent
        ColumnLayout {
            anchors.fill: parent
            BGTextEdit {
                id: txtCmd
                Layout.fillWidth: true
                implicitHeight: 100
            }
            Flickable {
                contentHeight: txtLog.height
                Layout.fillWidth: true
                Layout.fillHeight: true
                BGText {
                    id: txtLog
                    width: parent.width
                    text: BGLauncherLog.log
                    wrapMode: Text.Wrap
                }
            }
        }
    }
    header: BGArea {
        area: "banner"
        height: rl.height
        RowLayout {
            id: rl
            width: parent.width
            BGLineEdit { id: txtJs; Layout.fillWidth: true }
            BGButton {
                text: "exec"
                onClicked: {
                    txtCmd.text += txtJs.text + '\n';
                    eval (txtJs.text);
                    txtJs.text = "";
                    focus = true;
                }
            }
            BGButton {
                text: "clear"
                onClicked: {
                    BGLauncherLog.clear ();
                    focus = true;
                }
            }
        }
    }
}
