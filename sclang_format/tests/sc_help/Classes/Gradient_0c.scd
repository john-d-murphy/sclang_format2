// Source: Classes/Gradient.schelp block 0 (part 3/5)
(
w = Window.new.front;
v = CompositeView(w, Rect(50, 50, 300, 300));
c = Color.rand;
d = c.vary(0.15);
v.background = Gradient(c, d, \v);
[c, d].postln
)
