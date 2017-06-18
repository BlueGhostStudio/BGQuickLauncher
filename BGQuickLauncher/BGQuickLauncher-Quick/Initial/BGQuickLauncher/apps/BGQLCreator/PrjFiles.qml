import QtQuick 2.7
import BGControls 1.0
import BGStudio 1.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ColumnLayout {
    property string rootDir: project.rootDir
    property alias dir: fvPrjFiles.dir
    spacing: 0
    //BGText { text: rootDir }
    BGDialog {
        id: newFileDlg
        title: "New file"
        BGLineEdit {
            id: leFileName
        }
        onOpened: leFileName.text = ""
        onAccepted: {
            var tmpPath = BGFile.urlToPath (
                appsPath + "BGQLCreator/tmp");
            var fn = leFileName.text;
            var nfp = BGFile.urlToPath (fvPrjFiles.dir) + '/' + fn;
            if (/\.qml$/.test(fn))
                BGCmd.exec ('cp -r ' + tmpPath + '/qml.qml '
                    + nfp);
            else
                BGFile.writeFile (nfp, "");
        }
    }
    BGArea {
        area: "banner"
        Layout.fillWidth: true
        height: 42
        NavBarDeco { anchors.fill: parent }
        //implicitHeight: pathSelector.height + 10
        RowLayout {
            id: rlNavBar
            width: parent.width - 10
            anchors.centerIn: parent
            PrjPathSelector {
                id: pathSelector
                Layout.fillWidth: true
            }
            BGButton {
                area: "banner"
                icon: BGIcons.icon ("new", BGCtrlStyle.bannerbtnColor)
                onClicked: {
                    newFileDlg.open ()
                }
            }
        }
    }
    BGFileView {
        id: fvPrjFiles
        dir: rootDir//appsPath + project.appName
        showPathSelector: false
        onFileClicked: {
            console.log (path);
            prjEditArea.openFile (path);
            prjSwipe.currentIndex = 1;
        }
    }
}
