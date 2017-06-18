function objDeepClone (obj) {
    var newObj;
    newObj = new obj.constructor ();
    for (var k in obj) {
        if (typeof(obj[k]) == "object")
            newObj[k] = objDeepClone (obj[k]);
        else
            newObj[k] = obj[k];
    }
    
    return newObj;
}