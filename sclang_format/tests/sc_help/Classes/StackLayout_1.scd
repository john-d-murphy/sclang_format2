// Source: Classes/StackLayout.schelp block 1
(
var text, canvas;
text = TextView().string_("Hello world!").keyDownAction_({canvas.refresh});
canvas = UserView().acceptsMouse_(false).drawFunc_({
    var b = canvas.bounds();
    var str = text.string;
    Pen.translate( b.center.x, b.center.y );
    Pen.fillColor = text.palette.baseText.alpha_(0.1);
    str.do { |c|
        var x = 40.0.rand + 10.0;
        var r = c.asString.bounds.center_(0@0);
        Pen.push;
        Pen.rotate( 1.0.rand );
        Pen.translate( rand2(-0.3,0.3) * b.width, rand2(-0.3,0.3) * b.width );
        Pen.scale( x, x );
        Pen.stringCenteredIn(c.asString, r);
        Pen.pop;
    }
}).refresh;
w=Window().layout_( StackLayout( canvas, text ).mode_(\stackAll) ).front;
)
