import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import BGControls 1.0

Popup {
    id: dialog
    default property alias dlgContentData: dlgPage.data
    property alias title: txtTitle.text
    property var buttons: [{
        label: "Ok", result: 1
    }, {
        label: "Cancel", result: 0
    }]
    
    signal accepted (int result)
    signal rejected ()
    
    modal: true
    closePolicy: Popup.NoAutoClose
    //width: dlgPage.width + padding * 2
    //height: dlgPage.height + padding * 2
    padding: 5
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    background: Rectangle {
        color: BGCtrlStyle.bgColor
        radius: 5
        layer.enabled: true
        layer.effect: Glow {
            radius: 5
            samples: 11
            color: "#60000000"
            transparentBorder: true
        }
    }
    ColumnLayout {
        spacing: 5
        Text {
            id: txtTitle
            color: BGCtrlStyle.textColor
            font.pixelSize: 22
            font.bold: true
        }
        Rectangle {
            color: BGCtrlStyle.textColor
            Layout.fillWidth: true
            height: 2
        }
        Item {
            id: dlgPage
            Layout.margins: 5
            implicitWidth: childrenRect.width
            implicitHeight: childrenRect.height
        }
        RowLayout {
            spacing: 0
            Item { Layout.fillWidth: true }
            Repeater {
                model: dialog.buttons
                BGButton {
                    text: modelData.label
                    onClicked: {
                        if (modelData.result > 0)
                            dialog.accepted (modelData.result);
                        else
                            dialog.rejected ();
                        
                        dialog.close ();
                    }
                }
            }
        }
    }
    /*Page {
        id: dlgPage
        header: ColumnLayout {
            spacing: 0
            Text {
                id: txtTitle
                color: BGCtrlStyle.textColor
                font.pixelSize: 16
                font.bold: true
            }
            Rectangle {
                color: BGCtrlStyle.textColor
                Layout.fillWidth: true
                height: 2
            }
            //Text { text: dlgPage.childrenRect.height }
            //Text { text: dlgPage.height }
        }
        
        padding: 5
        background: Item {}
        
        Rectangle { width: 200; height: 200 }
        
        footer: RowLayout {
            spacing: 0
            Item { Layout.fillWidth: true }
            Repeater {
                model: dialog.buttons
                BGButton {
                    text: modelData.label
                    onClicked: {
                        if (modelData.result > 0)
                            dialog.accepted (modelData.result);
                        else
                            dialog.rejected ();
                        
                        dialog.close ();
                    }
                }
            }
        }
        
    }*/
}
