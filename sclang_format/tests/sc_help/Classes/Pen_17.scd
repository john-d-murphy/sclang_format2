// Source: Classes/Pen.schelp block 17
(
var w = Window("smoothing", Rect(100, 200, 500, 300)).front;
w.view.background_(Color.white);
w.drawFunc = { |v|
    Pen.strokeColor = Color.grey(0.25);
    Pen.smoothing_(false); //no anti-aliasing
    50.do{|i|
        Pen.moveTo(50@50.rrand(250));
        Pen.lineTo(250@50.rrand(250));
    };
    Pen.stroke;
    Pen.smoothing_(true); //anti-aliasing (default)
    50.do{|i|
        Pen.moveTo(250@50.rrand(250));
        Pen.lineTo(450@50.rrand(250));
    };
    Pen.stroke;
};
)
