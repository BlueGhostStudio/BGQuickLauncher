function APP_input (context, color, width, height, padding) {
    context.reset ();
    context.fillStyle = Qt.darker (color, 1.5);//BGColor.contrast(BGCtrlStyle.bgColor, 0.1);
    context.roundedRect (0, 0, width, height, padding, padding);
    context.fill ();
    
    context.beginPath ();
    context.fillStyle = color;
    context.roundedRect (1, 1, width - 2, height - 2, padding - 1, padding -1);
    context.fill ();
}

function APP_btn_Glass (context, color, width, height, pressed, circle) {
    context.reset ();
    context.save ();
    var stateColor = color;
    if (pressed) {
        context.shadowBlur = 0.5;
        stateColor = BGColor.contrast (color, 0.2); 
    } else
        context.shadowBlur = 2;
    
    var gradient = context.createLinearGradient(2.5, 2.5, 2.5, height - 2.5);
    gradient.addColorStop(0, Qt.lighter (stateColor, 1.2));
    gradient.addColorStop(0.49, stateColor);
    gradient.addColorStop(0.51, Qt.darker (stateColor, 1.2));
    gradient.addColorStop(1, stateColor);
    
    context.fillStyle = gradient;

    var radius = circle ? (width - 5) / 2 : 5;
    context.roundedRect (2.5, 2.5, width - 5, height - 5, radius, radius);
    context.shadowColor ="#c0000000";
    
    context.fill ();
    context.restore ();
    context.strokeStyle = Qt.lighter (color, 1.5);
    context.stroke ();
}

function APP_input_Glass (context, color, width, height, padding) {
    APP_input (context, color, width, height, padding);
}

function APP_btn_Flat (context, color, width, height, pressed, circle) {
    context.reset ();
    context.save ();
    var stateColor = color;

    if (pressed) {
        context.shadowBlur = 0.5;
        stateColor = BGColor.contrast (color, 0.2); 
    } else
        context.shadowBlur = 2;
    
    context.fillStyle = stateColor;

    var radius = circle ? (width - 5) / 2 : 5;
    context.roundedRect (2.5, 2.5, width - 5, height - 5, radius, radius);
    context.shadowColor ="#c0000000";
    
    context.fill ();
    context.restore ();
    context.strokeStyle = "#c0ffffff"
    context.stroke ();
}

function APP_input_Flat (context, color, width, height, padding) {
    APP_input (context, color, width, height, padding);
}