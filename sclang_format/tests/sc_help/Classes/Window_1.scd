// Source: Classes/Window.schelp block 1
(
var w;
w = Window("my name is... panel", Rect(128, 64, 340, 360));

w.view.decorator = FlowLayout(w.view.bounds);
// w.addFlowLayout; // you can als write this instead of the line above

w.view.background = Color(0.6, 0.8, 0.8);
32.do({ |i|
    b = Button(w, Rect(rrand(20, 300), rrand(20, 300), 75, 24));
    b.states = [["Start "++i, Color.black, Color.rand],
        ["Stop "++i, Color.white, Color.red]];
});

w.front;
)
