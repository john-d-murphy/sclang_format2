// Source: Classes/Window.schelp block 7
(
var w, much = 0.02, string, synth;

w = Window.new("gui", Rect(100, 100, 300, 500)).front;
w.view.background_(Color.new255(153, 255, 102).vary);

string = "gui ".dup(24).join;

w.drawFunc = Routine {
    var i = 0;
    var size = 40;
    var func = { |i, j| sin(i * 0.07 + (j * 0.0023) + 1.5pi) * much + 1 };
    var scale;
    var font = Font("Helvetica", 40).boldVariant;
    loop {
        i = i + 1;
        Pen.font = font;
        string.do { |char, j|

            scale = func.value(i, j).dup(6);

            Pen.fillColor = Color.new255(0, 120, 120).vary;
            Pen.matrix = scale * #[1, 0, 0, 1, 1, 0];
            Pen.stringAtPoint(char.asString,
                ((size * (j % 9)) - 10) @ (size * (j div: 9))
            );
        };
        0.yield // stop here, return something unimportant
   }
};

{ while { w.isClosed.not } { w.refresh; 0.04.wait } }.fork(AppClock);

w.front;

)
