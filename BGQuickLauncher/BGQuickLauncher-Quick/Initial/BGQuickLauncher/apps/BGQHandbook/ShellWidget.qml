import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import BGControls 1.0
import BGStudio 1.0
import "SWCmps"

StackView {
    id: stvShellWiget
    property bool fillHeight: true
    Layout.fillHeight: true
    clip: true
    height: 512
    initialItem: CatePage {}
}
