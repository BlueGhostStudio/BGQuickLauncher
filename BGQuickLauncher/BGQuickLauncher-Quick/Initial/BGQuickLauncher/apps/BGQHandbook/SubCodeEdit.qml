import QtQuick 2.7
import BGControls 1.0
import QtQuick.Layouts 1.3
import BGStudio 1.0

ListView {
    id: lwSubCode
    property var subCodeData: BGMis.objDeepClone (csnsData.cs)
    signal deleted (int i)
    
    onDeleted: {
        subCodeDataChanged ()
        if (i >= subCodeData.length)
            i = subCodeData.length - 1;
        positionViewAtIndex (i, ListView.Beginning);
    }
    
    clip: true
    
    model: subCodeData
    spacing: 20
    
    delegate: BGFieldLayout {
        width: lwSubCode.width
        BGField {
            label: "Code"
            RowLayout {
                BGLineEdit {
                    Layout.fillWidth: true
                    text: modelData.c
                    onEditingFinished: {
                        subCodeData[index].c = text
                    }
                }
                BGButton {
                    icon:BGIcons.icon ("delete", color)
                    onClicked: {
                        subCodeData.splice (index, 1);
                        lwSubCode.deleted (index);
                    }
                }
            }
        }
        BGField {
            label: "Description"
            BGLineEdit {
                text: modelData.desc
                onEditingFinished: {
                    subCodeData[index].desc = text
                }
            }
        }
    }
    footer: BGButton {
        text: "Add code"
        onClicked: {
            subCodeData.push ({ c: "--", desc: "--" });
            subCodeDataChanged ();
            positionViewAtEnd ();
        }
    }
}
