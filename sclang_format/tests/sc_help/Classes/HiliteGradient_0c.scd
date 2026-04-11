// Source: Classes/HiliteGradient.schelp block 0 (part 3/4)
(
w = Window.new.front;
v = CompositeView(w, Rect(50,50,300,300));
c = Color.rand;
d = c.vary(0.15);
v.background = HiliteGradient(c, d, \v);
[c, d].postln
)
