// Source: Classes/Window.schelp block 0
(
var w;
w = Window("my name is... panel", Rect(128, 64, 340, 360));

32.do({ |i|
    b = Button(w, Rect(rrand(20, 300), rrand(20, 300), 75, 24));
    b.states = [["Start "++i, Color.black, Color.rand],
        ["Stop "++i, Color.white, Color.red]];
});
w.front;
)
