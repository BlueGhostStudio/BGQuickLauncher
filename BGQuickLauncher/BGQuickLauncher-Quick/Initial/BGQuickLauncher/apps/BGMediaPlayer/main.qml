import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import BGControls 1.0
import BGStudio 1.0
import BGQuickLauncher 1.0
import BGMedia 1.0
import QtMultimedia 5.7

BGPage {
    property Item shellWidget: PlayControl {}
    function setupWidget (widgetsArea) {
        widgetsArea.addWidget (shellWidget);
    }
    BGMediaLibrary {
        id: mediaLibrary
        loadingIndicator: popLoading
    }
    MediaPlayer {
        id: mediaPlayer
        source: mediaLibrary.medias[mediaList_library.currentIndex].file
        autoPlay: true
        onStatusChanged: {
            if(status == MediaPlayer.EndOfMedia)
                mediaList_library.currentIndex++
        }
    }
    Popup {
        id: popLoading
        background:Item {}
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        modal: true
        closePolicy: Popup.NoAutoClose
        BusyIndicator {
            anchors.centerIn: parent
            running: true
        }
    }
    header: BGButton {
        text: "Reload media library"
        onClicked: mediaLibrary.reload ()
    }
    /*header: BGArea {
        area: "banner"
        width: mediaList.width
        height: 32
        RowLayout {
            anchors.centerIn: parent
            width: parent.width - 24
            BGText {
                Layout.fillWidth: true; text: "Title"
                font.pixelSize: 22
                font.bold: true
            }
            BGText {
                Layout.preferredWidth: 80
                text: "Artists"
                font.pixelSize: 22
                font.bold: true
            }
            BGText {
                Layout.preferredWidth: 150
                text: "Album"
                font.pixelSize: 22
                font.bold: true
            }
        }
    }*/
    MediaList {
        id: mediaList_library
        model: mediaLibrary.medias
    }
    
    footer: PlayControl {
    }
    
    onParentChanged: mediaLibrary.load ()
    
    Component.onDestruction: shellWidget.destroy ()
}
