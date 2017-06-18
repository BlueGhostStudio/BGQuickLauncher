import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import BGControls 1.0
import BGStudio 1.0
import QtQml.Models 2.2
import "private"

Popup {
    id: ringMenu
    background: Item {}
    property real itemWidth: 48
    property real itemHeight: 48
    property real centerX: 0
    property real centerY: 0
    property var allRep: [repeater, repeater1, repeater2]
    property var radius: [96, 128, 160]
    
    property int subMenuIndex: -1
    property var subMenu: null
    property alias model: repeater.model
    property alias model1: repeater1.model
    property alias model2: repeater2.model
    
    signal accepted (var value, int level, int index)
    
    function openSubMenu (l, i, menu) {
        if (subMenu !== null) {
            subMenu.close ();
            return;
        }
        var rep = l === 0 ? repeater : repeater2
        subMenuIndex = i;
        subMenu = menu;
        var item = rep.itemAt (i);
        var gp = item.mapToItem (ringMenu.parent, 0, 0);
        menu.centerX = gp.x + item.width / 2;
        menu.centerY = gp.y + item.height / 2;
        menu.open ();
        var tmpClosePolicy = ringMenu.closePolicy;
        ringMenu.closePolicy = Popup.NoAutoClose;
        for ( var j = 0; j < 3; j++) {
            rep = allRep[j];
            for (var k = 0; k < rep.count; k++) {
                if (i !== k || j !== l) {
                    rep.itemAt (k).opacity = j == l ? 0.1 : 0;
                }
            }
        }
        menu.closed.connect (function () {
            subMenuIndex = -1;
            subMenu = null;
            ringMenu.closePolicy = tmpClosePolicy;
            for ( var j = 0; j < 2; j++) {
                rep = allRep[j];
                for (var k = 0; k < rep.count; k++) {
                    rep.itemAt (k).opacity = 1;
                }
            }
        });
    }
    
    width: Math.max (radius[0], radius[1], radius[2]) * 2 + itemWidth
    height: Math.max (radius[0], radius[1], radius[2]) * 2 + itemHeight
    
    x: centerX - width / 2
    y: centerY - height / 2
    padding: 0
    
    Repeater {
        id: repeater
    }
    Repeater {
        id: repeater1
    }
    Repeater {
        id: repeater2
    }
    
    Component {
        id: enterAni
        RingMenuEnterAni {}
    }
    
    Component {
        id: exitAni
        RingMenuExitAni {}
    }
    property var enterAnis: []
    property var exitAnis: []
    function makeMenu () {
        enterAnis = [];
        exitAnis = [];
        for (var i = 0; i < 3; i++) {
            var rep = allRep[i];
            var perRadin = Math.PI * 2 / rep.count;
            for (var j = 0; j < rep.count; j++) {
                var radin = j * perRadin - Math.PI / 2
                var item = rep.itemAt (j);
                item.x = width / 2
                    + (Math.cos (radin) * radius[i]//(i == 0 ? radius : radius2)
                    - item.width / 2)
                item.y = height / 2
                    + (Math.sin (radin) * radius[i]//(i == 0 ? radius : radius2)
                    - item.height / 2)
                item.scale = 0;
                
                var aniI = j
                if (i > 0)
                    aniI += repeater.count;
                if (i > 1)
                    aniI += repeater1.count;
                enterAnis.push (enterAni.createObject (null, {
                    index: aniI,
                    target: item
                }));
                exitAnis.push (exitAni.createObject (null, {
                    index: aniI,
                    target: item
                }));
            }
        }
        enterTrans.animations = enterAnis;
        exitTrans.animations = exitAnis;
    }
    enter: Transition {
        id: enterTrans
    }
    exit: Transition {
        id: exitTrans
    }
    Component.onCompleted: {
        if (model != null) {
            model.menu = ringMenu;
            model.level = 0;
        } else
            radius[0] = 0;
            
        if (model1 != null) {
            model1.menu = ringMenu;
            model1.level = 1;
        } else
            radius[1] = 0;
        
        if (model2 != null) {
            model2.menu = ringMenu;
            model2.level = 2;
        } else
            radius[2] = 0
        
        makeMenu ();
    }
}
