import QtQuick 2.7
import QtWebView 1.1
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import BGControls 1.0

SwipeView {
    id: swipeView
    clip: true
    Rectangle {
        color: "Black"
        ColumnLayout {
            anchors.centerIn: parent
            Text {
                color: "white"
                text: "因平臺限制，WebView與Qml元素無法相互重疊，\n"
                    + "瀏覽窗口任何情況均為置頂，即意味著總是阻擋了Shell。\n"
                    + "在需要時，先回到到此頁再進行ShellD的操作。\n"
                    + "向右滑動進入瀏覽窗口"
            }
            RowLayout {
                Text {
                    color: "white"
                    font.pixelSize: 32
                    text: "All Qml types"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            webView.url = "http://doc.qt.io/qt-5/qmltypes.html"
                            swipeView.currentIndex = 1
                        }
                    }
                }
                Rectangle {
                    Layout.fillHeight: true
                    width: 2
                    color: "white"
                }
                Text {
                    color: "white"
                    font.pixelSize: 32
                    text: "Bing.com"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            webView.url = "http://bing.com"
                            swipeView.currentIndex = 1
                        }
                    }
                }
            }
        }
    }
    //⎗⟳⇨⇦⌫↻
    Page {
        header: RowLayout {
            spacing: 0
            BGButton {
                text: "⇠"
                Layout.preferredWidth: 32
                onClicked: swipeView.currentIndex = 0
            }
            BGButton {
                text: "⇦"
                visible: webView.canGoBack
                onClicked: webView.goBack ()
            }
            BGButton {
                text: "⇨"
                visible: webView.canGoForward
                onClicked: webView.goForward ()
            }
            BGButton {
                text: "↻"
                onClicked: webView.reload ()
            }
            BGLineEdit {
                id: tlUrl
                Layout.fillWidth: true
                text: webView.url
                Component.onCompleted: {
                    input.pressed.connect (function () {
                        webView.visible = false
                    });
                }
            }
            BGButton {
                text: "GO"
                onClicked: {
                    var url = tlUrl.text;
                    if (!/^https?:\/\//.test (url))
                        url = "http://" + url;
                    webView.url = url
                    webView.visible = true
                }
            }
            BGButton {
                text: "Cancel"
                visible: !webView.visible
                onClicked: webView.visible = true
            }
        }
        WebView {
            id: webView
            anchors.fill: parent
            //visible: false
            //Layout.fillWidth: true
            //Layout.fillHeight: true
            url: "http://jandan.net"
        }
    }
}
