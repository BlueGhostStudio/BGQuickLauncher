import QtQuick 2.7
import QtQuick.Controls 2.0
//import "CopyFiles.js" as CF

StackView {
    id: mainStackView
    initialItem: WelcomePage {}
    pushEnter: Transition {}
    pushExit: Transition {}
}
