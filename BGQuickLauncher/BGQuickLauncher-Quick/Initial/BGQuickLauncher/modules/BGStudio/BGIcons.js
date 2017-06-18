function icon (fileName, color) {
    var brightness;
    if (color && Math.max (color.r, color.g, color.b) <= 0.5)
        brightness = "dark/";
    else
        brightness = "light/";
    return modulesPath + "BGStudio/icons/"
        + brightness
        + fileName + ".png";
}