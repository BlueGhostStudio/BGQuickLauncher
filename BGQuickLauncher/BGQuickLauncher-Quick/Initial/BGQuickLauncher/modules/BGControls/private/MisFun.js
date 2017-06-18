function valueIndex (value, valueField, model) {
    if (valueField) {
        for (var x in model) {
            if (model[x][valueField] === value)
                return x;
        }
    } else
        return value;
    
    return -1;
}

function value (currentIndex, valueField, model) {
    return currentIndex >= 0 ? (valueField ? model[currentIndex][valueField] : currentIndex) : null
}
