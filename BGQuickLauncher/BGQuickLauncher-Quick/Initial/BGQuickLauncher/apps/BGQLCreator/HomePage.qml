import QtQuick 2.7
import QtQuick.Layouts 1.3
import BGControls 1.0
import BGStudio 1.0
import BGQuickLauncher 1.0
import QtQuick.Controls 2.0
import QtQuick.Window 2.2

BGPage {
    id: homePageRootItem
    property bool requestRefresh: false
    header: BGArea {
        area: "banner"
        height: txtHeader.height + 20
        BGText {
            id: txtHeader
            text: "Blue Ghost Quick creator"
            width: parent.width - 20
            anchors.centerIn: parent
            font.pixelSize: Screen.height >= 800 ? 32 : 22
            font.bold: true
        }
    }//SubPageHeader { text: "Projects" }
    
    StackView.onStatusChanged: {
        if (StackView.status == StackView.Active && requestRefresh) {
            refreshProjects ();
            requestRefresh = false;
        }
    }
    
    Component {
        id: prjPageCmp
        PrjPage {}
    }
    
    BGDialog {
        id: newPrjDlg
        title: "new project"
        BGLineEdit {
            id: lePrjName
        }
        onOpened: lePrjName.text = ""
        onAccepted: {
            var basePath;
            switch (swvPrjType.currentIndex) {
            case 0:
                basePath = appsPath;
                break;
            case 1:
                basePath = modulesPath;
                break;
            case 2:
                basePath = shellPath;
                break;
            }
            var tmpPath = BGFile.urlToPath (
                appsPath + "BGQLCreator/tmp");
            var newPrj = BGFile.urlToPath (
                basePath + lePrjName.text + '/');
            
            BGCmd.exec ("mkdir " + newPrj);
            
            BGCmd.exec ('cp -r ' + tmpPath + '/main.qml ' + newPrj);
            BGCmd.exec ('cp -r ' + tmpPath + '/appProp ' + newPrj);
        }
    }
    
    function openProject (prj) {
        StackView.view.push (prjPageCmp, { "project": prj });
        //console.log ("ok");
    }
    
    function refreshProjects () {
        appPrjs.refresh ();
    }
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        BGTabBar {
            id: tbPrjType
            Layout.fillWidth: true
            bgColor: BGCtrlStyle.bannerbgColor
            font.pixelSize: 22
            font.bold: true
            currentIndex: swvPrjType.currentIndex
            model: ["Apps", "Modules", "Shell"]
        }
        StackLayout {
            id: swvPrjType
            currentIndex: tbPrjType.currentIndex
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: Screen.height >= 800 ? 10 : 0
            PrjList {
                id: appPrjs
                path: appsPath
                type: 0
            }
            PrjList {
                id: modulePrjs
                path: modulesPath
                type: 1
            }
            PrjList {
                id: shellPrjs
                path: shellPath
                type: 2
            }
        }
        RowLayout {
            Item { Layout.fillWidth: true }
            Layout.margins: Screen.height >= 800 ? 5 : 0
            BGButton {
                text: "New Project"
                font.pixelSize: Screen.height >= 800 ? 32 : 16
                font.bold: true
                onClicked: {
                    newPrjDlg.open ()
                }
            }
        }
    }
}
