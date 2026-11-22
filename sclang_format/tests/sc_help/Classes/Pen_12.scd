// Source: Classes/Pen.schelp block 12
(
w = Window.new.front;
w.view.background_(Color.white);
w.drawFunc = {
    Pen.strokeColor = Color.green;
    Pen.translate(200, 100);
    Pen.scale(0.5, 2);
    Pen.moveTo(0@0); // you have to set a starting point...
    Pen.lineTo(50@100);
    Pen.lineTo(100@100);
    Pen.lineTo(0@150);
    Pen.lineTo(-100@100);
    Pen.lineTo(-50@100);
    Pen.lineTo(0@0);
    Pen.stroke
};
w.refresh;
)
