import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

ColumnLayout {
    id: fieldLayout
    property string area
    property int maxFieldWidth : 0
    Component.onCompleted: {
        for (var x in children) {
            var item = children[x];
            if (item.objectName === "BGField") {
                maxFieldWidth = Math.max (item.labelImplicitWidth, maxFieldWidth);
                item.area = area
            }
        }
    }
}
