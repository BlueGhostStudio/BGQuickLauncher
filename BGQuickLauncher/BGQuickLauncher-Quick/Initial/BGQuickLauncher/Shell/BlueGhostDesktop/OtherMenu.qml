import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import BGControls 1.0
import BGStudio 1.0

RowLayout {
    ListView {
        id: lvCateMenu
        Layout.preferredWidth: parent.width * 0.3
        Layout.fillHeight: true
        clip: true
        currentIndex: -1
        model: launcherData.cateModel ()
        delegate: Text {
            color: "white"
            font.pixelSize: 22
            font.bold: lvCateMenu.currentIndex == index
            opacity: lvCateMenu.currentIndex == index ? 1 : 0.25
            text: modelData
            width: lvCateMenu.width
            height: implicitHeight + 10
            verticalAlignment: Text.AlignVCenter
            leftPadding: 5
            elide: Text.ElideRight
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    lvCateMenu.currentIndex = index
                    lvAppsMenu.model = launcherData.appModel (modelData)
                    appsMenuAni.restart ();
                }
            }
            Behavior on opacity { NumberAnimation { duration: 250 }}
        }
        highlight: Rectangle { color: "#30ffffff" }
    }
    Rectangle {
        width: 2
        color: "#30ffffff"
        Layout.fillHeight: true
    }
    ListView {
        id: lvAppsMenu
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true
        spacing: 5
        delegate: ColumnLayout {
            spacing: 0
            Text {
                color: "white"
                font.pixelSize: 22
                font.bold: true
                text: modelData.title
                opacity: maAppsMenu.pressed ? 1 : 0.25
                elide: Text.ElideRight
                MouseArea {
                    id: maAppsMenu
                    anchors.fill: parent
                    onClicked: {
                        launcher.newInstance(modelData.appName);
                        panel.close ();
                    }
                }
            }
            Text {
                color: "white"
                text: modelData.description
                font.pixelSize: 16
                font.italic: true
                visible: text.length > 0
                opacity: 0.25
                elide: Text.ElideRight
            }
        }
        NumberAnimation on opacity {
            id: appsMenuAni
            from: 0; to: 1; duration: 250
        }
    }
}

/*BGPage {
    property string category
    
    header: BGArea {
        area: "banner"
        height: rlHeader.implicitHeight
        RowLayout {
            id: rlHeader
            anchors.fill: parent
            BGButton {
                icon: BGIcons.icon("back", BGCtrlStyle.bannerbtnColor)//"arrowBack.png"
                onClicked: stvMenu.backToCateMenu ()
            }
            BGText {
                text: category
                Layout.fillWidth: true
                font.pixelSize: 22
                font.bold: true
            }
        }
    }
    
    Flickable {
        anchors.fill: parent
        anchors.margins: 10
        contentHeight: flApps.height
        Flow {
            id: flApps
            width: parent.width
            spacing: 5
            Repeater {
                id: repeater
                model: launcherData.appModel (category)
                AppIcon {
                    app: modelData
                    onClicked: panelRootItem.close ()
                }
            }
        }
    }
    
    Component.onCompleted: {
        panelRootItem.reloadedApps.connect (function () {
            if (category)
                repeater.model = launcherData.appModel (category);
        });
    }
}*/
