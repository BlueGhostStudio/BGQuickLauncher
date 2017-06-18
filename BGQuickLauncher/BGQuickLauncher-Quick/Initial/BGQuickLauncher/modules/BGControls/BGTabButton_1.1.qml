import QtQuick 2.7
import BGCanvas 1.0
import BGControls 1.0
import BGStudio 1.0

BGCanvas {
    id: tabBarBtn
    
    property int padding: tabBar.tabPadding
    property int radius: tabBar.tabRadius
    
    property bool actived: true
    property alias label: txtLabel.text
    property font font
    
    font.bold: actived
    font.pixelSize: tabBar.font.pixelSize - (actived ? 0 : 5)
    
    width: Math.floor (txtLabel.implicitWidth + padding * 4)
    height: Math.floor (font.pixelSize + padding * 2 + 10)
    
    anchors.bottom: parent.bottom
    anchors.bottomMargin: actived ? 0 : 2
    
    property list<BGPathBase> activeTab: [
        BGPath {
            x: 1
            y: tabBarBtn.height - 2
            fillColor: "#90000000"
            elems: [
                BGArcTo {
                    x: 1
                    y: 1
                    width: tabBarBtn.radius * 2
                    height: tabBarBtn.radius * 2
                    startAngle: 180
                    arcLength: -90
                },
                BGArcTo {
                    x: tabBarBtn.width - tabBarBtn.radius * 2 - 1
                    y: 1
                    width: tabBarBtn.radius * 2
                    height: tabBarBtn.radius * 2
                    startAngle: 90
                    arcLength: -90
                },
                BGLineTo {
                    x: tabBarBtn.width - 1
                    y: tabBarBtn.height - 2
                }
            ]
        },
        BGPath {
            x: 2
            y: tabBarBtn.height - 1
            fillColor: "#c0ffffff"
            elems: [
                BGArcTo {
                    x: 2
                    y: 2
                    width: (tabBarBtn.radius - 1) * 2
                    height: (tabBarBtn.radius - 1) * 2
                    startAngle: 180
                    arcLength: -90
                },
                BGArcTo {
                    x: tabBarBtn.width - (tabBarBtn.radius - 1) * 2 - 2
                    y: 2
                    width: (tabBarBtn.radius - 1) * 2
                    height: (tabBarBtn.radius - 1) * 2
                    startAngle: 90
                    arcLength: -90
                },
                BGLineTo {
                    x: tabBarBtn.width - 2
                    y: tabBarBtn.height - 1
                }
            ]
        },
        BGPath {
            x: 3
            y: tabBarBtn.height
            //fillColor: "#ccc"
            fillStyle: Qt.LinearGradientPattern
            gradient: {
                "start": Qt.point (0, 0),
                "end": Qt.point (0, tabBarBtn.height),
                "stops": [
                    { "pos": 0, "color": BGCtrlStyle.highlight },
                    { "pos": 0.4, "color": tabBar.color }
                ]
            }
            elems: [
                BGArcTo {
                    x: 3
                    y: 3
                    width: (tabBarBtn.radius - 2) * 2
                    height: (tabBarBtn.radius - 2) * 2
                    startAngle: 180
                    arcLength: -90
                },
                BGArcTo {
                    x: tabBarBtn.width - (tabBarBtn.radius - 2) * 2 - 3
                    y: 3
                    width: (tabBarBtn.radius - 2) * 2
                    height: (tabBarBtn.radius - 2) * 2
                    startAngle: 90
                    arcLength: -90
                },
                BGLineTo {
                    x: tabBarBtn.width - 3
                    y: tabBarBtn.height
                }
            ]
        }
    ]
    property list<BGPathBase> inactiveTab: [
        BGPath {
            x: 1
            y: tabBarBtn.height
            fillColor: Qt.rgba (tabBar.color.r, tabBar.color.g, tabBar.color.b, 0.5)//Qt.darker (tabBar.color, 1.2)
            elems: [
                BGArcTo {
                    x: 1
                    y: 1
                    width: (tabBarBtn.radius) * 2
                    height: (tabBarBtn.radius) * 2
                    startAngle: 180
                    arcLength: -90
                },
                BGArcTo {
                    x: tabBarBtn.width - (tabBarBtn.radius) * 2 - 1
                    y: 1
                    width: (tabBarBtn.radius) * 2
                    height: (tabBarBtn.radius) * 2
                    startAngle: 90
                    arcLength: -90
                },
                BGLineTo {
                    x: tabBarBtn.width - 1
                    y: tabBarBtn.height
                }
            ]
        }
    ]
    paths: actived ? activeTab : inactiveTab
    onActivedChanged: {
        update ();
    }
    Text {
        id: txtLabel
        anchors.centerIn: parent
        font: tabBarBtn.font
        text: tabBar.displayField.length > 0
            ? modelData[tabBar.displayField] : modelData
        color: BGColor.contrast (tabBar.color, 0.5);
        opacity: tabBarBtn.actived ? 1 : 0.5
    }
    
    MouseArea {
        anchors.fill: parent
        onClicked: {
            lvTabBar.currentIndex = index
        }
    }
}
