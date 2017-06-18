import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

GridLayout {
    id: rootItem
    property int level: 48
    property int hSel: 0
    property int sSel: 0
    property int vSel: 0
    readonly property real hue: hSel / level
    readonly property real saturation: sSel / level
    readonly property real lightness: vSel / level
    property real alpha: 1
    property int cWidth: Math.floor (250/(level + 1))
    readonly property color color: Qt.hsva (hue, saturation, lightness, alpha)
    property color currentColor: "red"
    
    rows: 2
    columns: 2
    
    //onCurrentColorChanged: setColor (currentColor)
    
    function setColor (testColor) {
        var max = "r"
        var min = "r"
        if (testColor.g > testColor[max])
            max = "g"
        else
            min = "g"
        
        if (testColor.b > testColor[max])
            max = "b"
        else if (testColor.b <= testColor[min])
            min = "b"
        
        var rang = testColor[max]-testColor[min];
        var min_max_plus = testColor[max]-testColor[min];
        
        var h
        if (testColor[max] === testColor[min])
            h = 0;
        else if (max === "r") {
            h = 60 * (testColor.g - testColor.b) / rang;
            if (h < 0)
                h += 360;
        } else if (max === "g")
            h = 60 * (testColor.b - testColor.r) / rang + 120;
        else if (max === "b")
            h = 60 * (testColor.r - testColor.g) / rang + 240;
        h = h/360
        var s = testColor[max] === 0 ? 0 : 1 - testColor[min] / testColor[max]
        var v = testColor[max]
        
        hSel = Math.floor (h * level);
        sSel = Math.floor (s * level);
        vSel = Math.floor (v * level);
        alpha = testColor.a
        currentColor = testColor
    }
    
    Canvas {
        id: svSel
        width: cWidth * (level + 1)
        height: cHeight * (level + 1)
        property int cHeight: cWidth
        contextType: "2d"
        smooth: false
        antialiasing: true
        onPaint: {
            var ctx = getContext ("2d");
            ctx.reset ();
            for (var i = 0; i <= level; i ++) {
                for (var j = 0; j <= level; j++) {
                    ctx.fillStyle = Qt.hsva (hue,
                        1 - i / level,
                        j / level, 1);
                    ctx.fillRect (j * cWidth, i * cHeight,
                        cWidth + 1, cHeight + 1);
                }
                    
            }
            ctx.strokeRect (0, 0, width, height)
        }
        Rectangle {
            color: "#00000000"
            border.color: "black"
            width: cWidth
            height: parent.cHeight
            x: vSel * cWidth
            y: (level - sSel) * parent.cHeight
        }
        MouseArea {
            anchors.fill: parent
            function updateValue () {
                var mx = mouseX// - parent.cWidth / 2
                var my = mouseY// - parent.cHeight / 2
                var l = level + 1
                
                var lv = Math.floor (mx * l / height);
                if (lv >= 0 && lv <= level)
                    vSel = lv;
                    
                    
                var sv = Math.floor (
                    (height - my) * l / width);
                if (sv >= 0 && sv <= level)
                    sSel = sv;
            }
            onClicked: updateValue ()
            onPositionChanged: updateValue ()
        }
        Component.onCompleted: {
            //requestPaint ();
            rootItem.hueChanged.connect (requestPaint);
        }
    }
    
    Image {
        Layout.preferredWidth: 64
        Layout.preferredHeight: svSel.height
        source: "imgs/Chequerboard.png"
        fillMode: Image.Tile
        clip: true
        LinearGradient {
            anchors.fill: parent
            start: Qt.point(0, 0)
            end: Qt.point(0, height)
            gradient: Gradient {
                GradientStop {
                    position: 0.0; color: "#00000000"
                }
                GradientStop { position: 1; color: "black" }
            }
            
            Rectangle {
                color: "#00000000"
                border.color: "white"
                width: parent.width
                height: 4
                x: 0
                y: alpha * (parent.height - height)
            }
            MouseArea{
                anchors.fill: parent
                function updateValue () {
                    alpha = mouseY / height
                    if (alpha < 0)
                        alpha = 0
                    else if (alpha > 1)
                        alpha = 1
                }
                onClicked: updateValue ()
                onPositionChanged: updateValue ()
            }
            
        }
    }
    
    Canvas {
        contextType: "2d"
        width: svSel.width
        height: 64
        onPaint: {
            var ctx = getContext ("2d");
            for(var i =0; i <= level; i++){
                ctx.fillStyle = Qt.hsva (i * 1 / level,
                        1, 1, 1);
                ctx.fillRect(cWidth * i, 0, cWidth, height);
                
            }
            ctx.strokeRect (0, 0, width, height)
        }
        Rectangle {
            color: "#00000000"
            border.color: "black"
            width: cWidth
            height: parent.height
            x: hSel * cWidth
        }
        MouseArea {
            anchors.fill: parent
            function updateValue () {
                var v = Math.floor (mouseX * (level + 1) / width);
                if (v >= 0 && v <= level)
                    hSel = v
            }
            onClicked: updateValue ()
            onPositionChanged: updateValue ()
        }
    }
    
    Image {
        Layout.preferredWidth: 64
        Layout.preferredHeight: 64
        source: "imgs/Chequerboard.png"
        fillMode: Image.Tile
        clip: true
        ColumnLayout {
            anchors.fill: parent
            spacing: 0
            Rectangle {
                height: 32
                width: 64
                color: rootItem.color
            }
            Rectangle {
                height: 32
                width: 64
                color: rootItem.currentColor
            }
        }
    }
}
