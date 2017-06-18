import QtQuick 2.7

QtObject {
    function cateModel () {
        var apps = launcher.appList;
        var categories = ["Default", "Tools", "Games", "Multimedia", "Develop"];
        for (var x in apps) {
            var cate = apps[x].category;
            if (categories.indexOf(cate) === -1)
                categories.push (cate);
        }
        return categories;
    }
    
    function appModel (cate) {
        var apps = launcher.appList;
        var cateApps = [];
        for (var x in apps) {
            if (apps[x].category === cate)
                cateApps.push (apps[x])
        }
        return cateApps;
    }
}
