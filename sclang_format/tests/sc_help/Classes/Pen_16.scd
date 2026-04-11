// Source: Classes/Pen.schelp block 16
(
w = Window.new.front;
w.view.background_(Color.white);
w.drawFunc = {
    // outline the clipping path
    Pen.moveTo(110@110);
    Pen.lineTo(290@110);
    Pen.lineTo(290@240);
    Pen.lineTo(110@240);
    Pen.lineTo(110@110);
    // now clip
    Pen.clip;

    // everything else we draw is now clipped
    Pen.fillColor = Color.yellow;
    Pen.fillRect(Rect(0,0,400,400));
    Pen.fillColor = Color.red;
    Pen.moveTo(200@100);

    Pen.lineTo(250@200);
    Pen.lineTo(300@200);
    Pen.lineTo(200@250);
    Pen.lineTo(100@200);
    Pen.lineTo(150@200);

    Pen.fill;
};
w.refresh;
)
