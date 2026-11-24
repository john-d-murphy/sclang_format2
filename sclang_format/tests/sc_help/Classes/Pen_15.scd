// Source: Classes/Pen.schelp block 15
(
// modified by an example of Stefan Wittwer
w = Window.new.front;
w.view.background_(Color.white);
w.drawFunc = {
    // paint origin
    Pen.fillColor = Color.gray(0, 0.5);
    Pen.addArc(0@0, 20, 0, 2pi);
    Pen.fill;
    Pen.width = 10;

    Pen.use { // draw something complex...
        Pen.width = 0.5;
        Pen.translate(100, 100);
        Pen.fillColor = Color.blue;
        Pen.addArc(0@0, 10, 0, 2pi);
        Pen.fill;
        20.do{
            Pen.moveTo(0@0);
            Pen.lineTo(100@0);
            Pen.strokeColor = Color.red(0.8, rrand(0.7, 1));
            Pen.stroke;
            Pen.skew(0, 0.1);
        };
    };

    // now go on with all params as before
    // translation, skewing, width, and color modifications do not apply
    Pen.line(10@120, 300@120);
    Pen.stroke;
};
w.refresh
)
