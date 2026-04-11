// Source: Classes/Pen.schelp block 18
(
w = Window.new.front;
w.view.background_(Color.white);
StaticText(w, Rect(0,0,200,20))
    .string_(" Change Line Cap & Join Styles: ");
y = PopUpMenu(w, Rect(200,0,130,20))
    .items_(["Butt - Miter", "Round - Round", "Square - Bevel"])
    .action_({w.refresh});
w.drawFunc = {
    Pen.strokeColor = Color.red;
    Pen.width_(8.0);
    Pen.capStyle_(y.value);
    Pen.joinStyle_(y.value);
    Pen.moveTo(200@100);
    Pen.lineTo(250@200);
    Pen.lineTo(300@200);
    Pen.lineTo(200@250);
    Pen.lineTo(100@200);
    Pen.lineTo(150@200);
    Pen.lineTo(200@100);
    Pen.stroke;
};
w.refresh;
)
