// Source: Classes/Pen.schelp block 13
(
w = Window.new.front;
w.view.background_(Color.white);
w.drawFunc = {
    Pen.fillColor = Color.green(0.5, 0.8);
    Pen.translate(200, 100);
    Pen.skew(0.5, 0.2);
    Pen.moveTo(0@0); // you have to set a starting point...
    Pen.lineTo(50@100);
    Pen.lineTo(100@100);
    Pen.lineTo(0@150);
    Pen.lineTo(-100@100);
    Pen.lineTo(-50@100);
    Pen.lineTo(0@0);
    Pen.fill
};
w.refresh;
)
