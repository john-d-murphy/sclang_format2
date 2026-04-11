// Source: Classes/Pen.schelp block 0
(
var w = Window("arcTo", Rect(100, 200, 300, 300)).front;
var r= 15;
w.drawFunc = { |v|
    Pen.fillColor = Color.blue;
    Pen.strokeColor = Color.red;
    Pen.moveTo(150@150);
    Pen.arcTo(200@150, 200@225, r);
    Pen.arcTo(200@225, 100@225, r);
    Pen.arcTo(100@225, 100@150, r);
    Pen.arcTo(100@150, 150@150, r);
    Pen.lineTo(150@150);
    Pen.fillStroke;
};
)
