import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import BGCanvas 1.0

Item {
    width: rw.width
    height: rw.height + 20
    /*
     * modelData.title 应用标题
     * modelData.iconSrc 应用图标
     * modelData.appName 应用名称
     * modelData.description 说明{}
    */
    Row {
        id: rw
        y: 10
        spacing: 5
        
        Rectangle{
            width:36
            height:36
            Image{
                x:2
                y:2
                width:32
                height:32
                source: appsPath + modelData.appName + "/" + modelData.iconSrc
            }
        }
        Column{
            Text{
                text:modelData.title
                color:'#fff'
            }
            Text{
                text: modelData.description
                color:'#eee'
            }
        }
    }
    /*paintScript: function (p) {
        p.setPen ("white", 2);
        p.drawLine (0, 0, width, 0);
        p.drawLine (0, height, width, height);
    }*/
    MouseArea{
      anchors.fill:parent
      onClicked: launcher.newInstance  (modelData.appName)
    }
}
