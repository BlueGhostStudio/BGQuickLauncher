.import BGStudio 1.0 as BGS

/*[
    {
        name: "cate",
        snapshots: []
    }
]*/
function init () {
    var hbPath = dataPath + "bgqhandbook";
    if (!BGS.BGFile.exists (hbPath)) {
        BGS.BGFile.writeFile (hbPath, "[]");
        hbData = [];
    } else
        hbData = JSON.parse (BGS.BGFile.readFile (hbPath));
    
    return data;
}

function save () {
    BGS.BGFile.writeFile (dataPath + "bgqhandbook",
        JSON.stringify (hbData));
}
