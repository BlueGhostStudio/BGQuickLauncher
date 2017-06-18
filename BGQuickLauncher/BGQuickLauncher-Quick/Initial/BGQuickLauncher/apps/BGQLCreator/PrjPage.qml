import QtQuick 2.7
import BGControls 1.0
import BGStudio 1.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2

CreatorPage {
    id: prjPage
    property var project
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        Component {
            id: tabHeader
            BGArea {
                area: "banner"
                height: clHeader.height + 20
                RowLayout {
                    id: clHeader
                    width: parent.width - 20
                    anchors.centerIn: parent
                    spacing: 0
                    GridLayout {
                        rows: 3
                        columns: 2
                        rowSpacing: 0
                        visible: project.type === 0
                        Layout.fillWidth: true
                        Image {
                            id: imgIcon
                            Layout.preferredWidth: 48
                            Layout.preferredHeight: 48
                            Layout.rowSpan: 3
                            source: appsPath + project.appName + "/" + project.iconSrc
                            onStatusChanged: if (status == Image.Error) {
                                                 source = BGIcons.icon ("default")
                                             }
                            visible: project.isApp
                            Component.onCompleted: {
                                projectChanged.connect (function () {
                                    source =
                                        appsPath + project.appName
                                        + "/" + project.iconSrc
                                });
                            }
                        }
                        BGText {
                            Layout.fillWidth: true;
                            text: project.appName
                            font.pixelSize: 10
                            font.bold: true
                            elide: Text.ElideRight
                        }
                        
                        BGText {
                            Layout.fillWidth: true;
                            text: project.title
                            font.pixelSize: 22
                            font.bold: true
                            elide: Text.ElideRight
                        }
                        
                        BGText {
                            Layout.fillWidth: true
                            text: project.description
                            font.pixelSize: 10
                            font.bold: true
                            elide: Text.ElideRight
                        }
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        visible: project.type !== 0
                        spacing: 0
                        BGText { text: project.type == 1 ? "Module" : "Shell" }
                        BGText {
                            Layout.fillWidth: true;
                            text: project.appName
                            font.pixelSize: 22
                            font.bold: true
                            elide: Text.ElideRight
                        }
                    }
                    BGButton {
                        iconSize: 32
                        icon: BGIcons.icon("home", BGCtrlStyle.bannerbtnColor)
                        onClicked: prjSwipe.currentIndex = 0
                    }
                    
                    BGButton {
                        iconSize: 32
                        icon: BGIcons.icon("edit", BGCtrlStyle.bannerbtnColor)
                        onClicked: prjSwipe.currentIndex = 1
                    }
                    BGButton {
                        iconSize: 32
                        icon: BGIcons.icon("play", BGCtrlStyle.bannerbtnColor)
                        visible: project.type === 0
                        onClicked: {
                            prjRun.run ();
                            prjSwipe.currentIndex = 2;
                        }
                        onPressAndHold: {
                            prjRun.run (true);
                            prjSwipe.currentIndex = 2;
                        }
                    }
                    BGButton {
                        iconSize: 32
                        icon: BGIcons.icon("stop", BGCtrlStyle.bannerbtnColor)
                        visible: project.type === 0
                        onClicked: {
                            prjRun.stop ();
                            prjSwipe.currentIndex = 2;
                        }
                    }
                    BGButton {
                        iconSize: 32
                        icon: BGIcons.icon("timer", BGCtrlStyle.bannerbtnColor)
                        onClicked: prjSwipe.currentIndex = 3
                    }
                    BGButton {
                        iconSize: 32
                        visible: project.type === 0
                        icon: BGIcons.icon ("settings", BGCtrlStyle.bannerbtnColor)
                        onClicked: prjSettings.open ()
                    }
                    BGButton {
                        iconSize: 32
                        icon: BGIcons.icon ("close", BGCtrlStyle.bannerbtnColor)
                        onClicked: back ()
                    }
                }
            }
        }
        Component {
            id: mobileHeader
            BGArea {
                area: "banner"
                height: clHeader.height
                RowLayout {
                    id: clHeader
                    width: parent.width
                    anchors.centerIn: parent
                    BGText {
                        text: project.appName
                        font.bold: true
                        elide: Text.ElideRight
                        Layout.maximumWidth: 100
                    }
                    BGText { text: "-" }
                    BGText {
                        text: project.title
                        font.bold: true
                        elide: Text.ElideRight
                        Layout.maximumWidth: 100
                    }
                    Item { Layout.fillWidth: true }
                    BGButton {
                        text: "Menu"
                        font.pixelSize: 16
                        BGMenu {
                            id: prjMenu
                            x: parent.width - width
                            y: parent.height
                            model: ["Home", "Edit", "Run", "Log", "Project Property", "Close"]
                            onActived: {
                                if (value ===  2)
                                    prjRun.run (true);
                                else if (value === 4)
                                    prjSettings.open ();
                                else if (value === 5)
                                    back ();
                                    
                                if (value < 4)
                                    prjSwipe.currentIndex = value;
                            }
                        }
                        onClicked: prjMenu.open ();
                    }
                }
            }
        }
        Loader {
            id: pageHeader
            Layout.fillWidth: true
            property var project: prjPage.project
            sourceComponent: Screen.height >= 800 ? tabHeader : mobileHeader
        }
        PrjSettings {
            id: prjSettings
        }
        Rectangle {
            color: BGCtrlStyle.bgColor
            //anchors.fill: parent
            Layout.fillWidth: true
            Layout.fillHeight: true
            SwipeView {
                id: prjSwipe
                anchors.fill: parent
                clip: true
                PrjFiles { id: prjFiles }
                PrjEditArea { id: prjEditArea }
                PrjRun { id: prjRun }
                PrjLog { id: prjLog }
            }
        }
    }
}
