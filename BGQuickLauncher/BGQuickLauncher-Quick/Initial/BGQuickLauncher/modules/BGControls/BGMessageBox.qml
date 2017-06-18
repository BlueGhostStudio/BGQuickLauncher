import QtQuick 2.7
import BGControls 1.0

BGDialog {
    id: dlgMessageBox
    property var yesCallback
    property var noCallback
    property var cancelCallback
    property var okCallback
    BGText {
        id: txtMessage
    }
    function question (title, message, ycb, ncb, ccb) {
        buttons = [{
            label: "Yes", result: 2
        }, {
            label: "No", result: 3
        }, {
            label: "Cancel", result: 0
        }]
        dlgMessageBox.title = title;
        txtMessage.text = message;
        dlgMessageBox.open ();
        yesCallback = ycb;
        noCallback = ncb;
        cancelCallback = ccb;
        okCallback = undefined;
    }
    onAccepted: {
        var cb = undefined;
        switch (result) {
        case 0:
            cb = cancelCallback;
            break;
        case 1:
            cb = okCallback;
            break;
        case 2:
            cb = yesCallback;
            break;
        case 3:
            cb = noCallback;
            break;
        }
        if (cb)
            cb ();
    }
}
