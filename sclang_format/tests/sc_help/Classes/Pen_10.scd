// Source: Classes/Pen.schelp block 10
(
w = Window.new.front;
w.view.background_(Color.white);
w.drawFunc = {
    Pen.strokeColor = Color.blue;
    Pen.translate(200,100); // 0@0 is now 200@100
    Pen.moveTo(0@0);
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
