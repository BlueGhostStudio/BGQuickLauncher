import QtQuick 2.7
import BGStudio 1.0
import QtQuick.Controls 2.0
import QtMultimedia 5.7
import "private/mediaTag.js" as Tag

Item {
    property var medias: []
    readonly property string tagsPath: dataPath + "mediaTags"
    property bool stored: BGFile.exists (tagsPath)
    property Popup loadingIndicator: Popup {
        Text { text: "loading" }
    }
    BGDirModel {
        id: dirModel
        dir: BGFile.standardLocations(BGFile.Music)[0]
        filter: BGFile.NoDotAndDotDot | BGFile.AllEntries
    }
    Timer {
        id: tmLoad
        interval: 250
        onTriggered: reload ();
    }
    /*Popup {
        id: popLoading
        background:Item {}
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        //modal: true
        //closePolicy: Popup.NoAutoClose
        BusyIndicator {
            anchors.centerIn: parent
            running: true
        }
        onOpened: tmLoad.start ()
    }*/
    
    function load () {
        if (!stored) {
            loadingIndicator.open ();
        } else
            medias = JSON.parse(BGFile.readFile (tagsPath));
    }
    function reload () {
        var fileList = dirModel.fileList;
        medias = [];
        //var tagsPath = dataPath + "mediaTags";
        for (var i in fileList)
            medias.push (Tag.loadTag (fileList[i].path));
        
        BGFile.writeFile(tagsPath, JSON.stringify(medias));
            
        mediasChanged ();
        loadingIndicator.close ();
    }
    Component.onCompleted: {
        loadingIndicator.opened.connect (function () {
            tmLoad.start ();
        });
    }
}
