// Source: Overviews/GenericCollectors.schelp block 4 (part 5/7)
(
w = Window("move me", Rect(300, 300, 600, 40)).front; w.addFlowLayout;
a = Slider(w, Rect(0, 0, 580, 30));
a.action = a.action.addFunc { "I am moved".postln };
)
