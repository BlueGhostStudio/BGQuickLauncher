function codeToStr (data, start, len) {
    var str = "";
    var i = 0;
    if (data [start] == 0)
        i = 1;
    for (; i < len; i++) {
        var ch = data[start + i];
        if (ch == 0)
            break;
        str += "%" + ("00" + ch.toString (16)).slice(-2);
        //str += String.fromCharCode (ch);
    }
    try {
        str = decodeURIComponent(str);
    } catch (err) {
        str = "";
    }
    return str//decodeURIComponent(str);
}

function loadTag (mediaFileName) {
    var tag = {}
    tag.file = mediaFileName;
    tag.vaild = true;
    var mf = BGFile.open (mediaFileName);
    
    if (!mf) {
        console.log ("cant open");
        return {};
    }
    
    // read id3 header
    var d = mf.read (3).toString ();
    if (d != "ID3") {
        tag.vaild = false;
        return tag;
    }
    mf.seek (6);
    d = mf.readb (4);
    var tSize = d[0] << 21 | d[1] << 14 | d[2] << 7 | d[3];
    
    d = mf.readb (tSize - 10);
    var pos = 0;
    while (pos < tSize - 10 && d[pos] > 0) {
        var fid = codeToStr (d, pos, 4);
        pos += 4;
        var fSize = d[pos] << 24 | d[pos + 1] << 16
            | d[pos + 2] << 8 | d[pos + 3];
        pos += 6;
        var value = codeToStr (d, pos, fSize);
        pos += fSize;
        tag [fid] = value;
    }
    BGFile.close (mf);
    return tag;
}

/*function loadTags (fileList) {
    var tags = [];
    var tagsPath = dataPath + "mediaTags";
    if (!BGFile.exists (tagsPath))
        for (var i in fileList) {
            tags.push (loadTag (fileList[i].path));
        BGFile.writeFile(tagsPath, JSON.stringify(tags));
    } else
        tags = JSON.parse(BGFile.readFile (tagsPath));
}*/
