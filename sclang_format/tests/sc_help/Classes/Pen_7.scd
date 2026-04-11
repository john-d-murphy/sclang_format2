// Source: Classes/Pen.schelp block 7
(
w = Window.new.front;
w.view.background_(Color.white);
w.drawFunc = {
    // set the Color
    Pen.fillColor = Color.red;
    Pen.moveTo(200@100);

    Pen.lineTo(250@200);
    Pen.lineTo(300@200);
    Pen.lineTo(200@250);
    Pen.lineTo(100@200);
    Pen.lineTo(150@200);
    Pen.lineTo(200@100);

    Pen.draw(4); // fill and then stroke
};
w.refresh;
)
