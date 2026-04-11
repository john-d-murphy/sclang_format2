// Source: Classes/Pen.schelp block 11
(
w = Window.new.front;
w.view.background_(Color.clear);
w.drawFunc = {
    Pen.strokeColor = Color.black;
    35.do { // draw 35 lines
        Pen.moveTo(0@0);
        Pen.lineTo(50@350);
        Pen.translate(10, 0); // shift 10 to the right every time
        Pen.stroke
    }
};
w.refresh;
)
