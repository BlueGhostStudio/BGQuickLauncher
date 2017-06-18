import QtQuick 2.7
import QtQuick.Layouts 1.3
import BGControls 1.0
import BGQuickLauncher 1.0
import BGStudio 1.0
import QtMultimedia 5.7
import QtQuick.Window 2.2

BGArea {
    area: "banner"
    height: rlControls.implicitHeight + 20
    RowLayout {
        id: rlControls
        anchors.fill: parent
        anchors.margins: 10
        ColumnLayout {
            Layout.fillWidth: true
            BGText {
                Layout.fillWidth: true
                text: mediaPlayer.metaData.title
                font.pixelSize: Screen.width > 400 ? 22 : 16
                font.bold: true
            }
            BGText {
                Layout.fillWidth: true
                text: "<b>Arists:</b>"
                    + mediaPlayer.metaData.contributingArtist
                font.pixelSize: Screen.width > 400 ? 16 : 10
            }
            BGText {
                Layout.fillWidth: true
                text: "<b>Album:</b>" + mediaPlayer.metaData.albumTitle
                font.pixelSize: Screen.width > 400 ? 16 : 10
            }
        }
        //RowLayout {
            BGButton {
                iconSize: Screen.width > 400 ? 32 : 22
                icon: BGIcons.icon ("backward", color);
                onClicked: {
                    if (mediaList_library.currentIndex > 0)
                        mediaList_library.currentIndex--;
                }
            }
            BGButton {
                iconSize: Screen.width > 400 ? 48 : 32
                icon: mediaPlayer.playbackState == MediaPlayer.PlayingState
                    ? BGIcons.icon ("pause", color)
                    : BGIcons.icon ("play", color)
                onClicked: {
                    if (mediaPlayer.playbackState == MediaPlayer.PlayingState)
                        mediaPlayer.pause ();
                    else
                        mediaPlayer.play ();
                }
            }
            BGButton {
                iconSize: Screen.width > 400 ? 32 : 22
                icon: BGIcons.icon ("forward", color);
                onClicked: {
                    if (mediaList_library.currentIndex
                        < mediaList_library.model.length)
                        mediaList_library.currentIndex++
                }
            }
        //}
    }
}