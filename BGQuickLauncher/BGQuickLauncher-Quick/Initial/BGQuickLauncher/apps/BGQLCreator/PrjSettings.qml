import QtQuick 2.7
import BGControls 1.0
import BGStudio 1.0

BGDialog {
    title: "Project Settings"
    BGFieldLayout {
        BGField {
            label: "Title"
            BGLineEdit { id: leTitle }
        }
        
        BGField {
            label: "Icon"
            BGLineEdit { id: leIcon }
        }
        
        BGField {
            label: "Description"
            BGTextEdit { id: teDesc; height: 80 }
        }
        
        BGField {
            label: "Category"
            BGComboBox {
                id: cbCate
                displayField: "l"
                valueField: "v"
                model: [{
                    l:"Default", v:"Default"
                }, {
                    l: "Tools", v: "Tools"
                }, {
                    l: "Games", v: "Games"
                }, {
                    l: "Graphics", v: "Graphics"
                }, {
                    l: "Multimedia", v: "Multimedia"
                }, {
                    l: "Web", v: "Web"
                }, {
                    l: "Develop", v: "Develop"
                }, {
                    l: "Settings", v: "Settings"
                }]
            }
        }
    }
    onOpened: {
        var title = BGSettings.value ("title","");
        var icon = BGSettings.value ("iconSrc");
        var desc = BGSettings.value ("description");
        var cate = BGSettings.value ("category");
        cate = cate ? cate : "default";
        leTitle.text = title ? title : "";
        leIcon.text = icon ? icon : "";
        teDesc.text = desc ? desc : "";
        cbCate.currentIndex = cbCate.valueIndex (cate);
    }
    onAccepted: {
        BGSettings.setValue ("title", leTitle.text);
        BGSettings.setValue ("iconSrc", leIcon.text);
        BGSettings.setValue ("description", teDesc.text);
        BGSettings.setValue ("category", cbCate.value);
        project.title = leTitle.text
        project.description = teDesc.text
        project.iconSrc = leIcon.text
        projectChanged ();
        requestRefresh = true;
        //refreshProjects ();
    }
    Component.onCompleted: {
        BGSettings.open (project.rootDir + "/appProp");
    }
}