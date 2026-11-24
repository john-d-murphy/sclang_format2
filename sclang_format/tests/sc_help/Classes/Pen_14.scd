// Source: Classes/Pen.schelp block 14
(
w = Window.new.front;
w.view.background_(Color.white);
c = 0;
w.drawFunc = {
    Pen.translate(220, 200);
    10.do({
        Pen.translate(0, 10);
        Pen.fillColor = Color.hsv(c.fold(0, 1), 1, 1, 0.5);
        Pen.moveTo(0@0); // you have to set a starting point...
        Pen.lineTo(50@100);
        Pen.lineTo(100@100);
        Pen.lineTo(0@150);
        Pen.lineTo(-100@100);
        Pen.lineTo(-50@100);
        Pen.lineTo(0@0);
        Pen.fill;
        Pen.rotate(0.2pi);
        c = c + 0.1;
    });
};
w.refresh;
)
