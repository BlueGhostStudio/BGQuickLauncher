.import BGStudio 1.0 as BGStudio

var pluginsPath
    = BGStudio.BGFile.standardLocations (BGStudio.BGFile.Data)[0]
        + "/plugins"
var launcherPath
    = BGStudio.BGFile.standardLocations (BGStudio.BGFile.Documents)[0]
        + "/BGQuickLauncher"

function copyFile (file, rootScrDir, rootDistDir) {
    var distPath = rootDistDir
        + file.path.replace (":/Initial/" + rootScrDir, "");
    if (file.isDir)
        BGStudio.BGFile.mkpath (distPath);
    else {
        var src = file.path.replace (":", "qrc://");
        BGStudio.BGFile.cp (src, distPath);
    }
}

function copyAllFiles (dir, rootScrDir, rootDistDir) {
    var files = BGStudio.BGFile.fileList (dir);
    for (var i in files) {
        copyFile (files[i], rootScrDir, rootDistDir);
        if (files[i].isDir)
            copyAllFiles (files[i].path.replace (":", "qrc://"),
                rootScrDir, rootDistDir);
    }
}

/*function recursionDir (dir, cb) {
    var files = BGFile.fileList (dir);
    for (var i in files) {
        cb (files[i]);
        if (files[i].isDir)
            recursionDir (files[i].path.replace (":", "qrc://"), cb);
    }
}*/
