// Source: Classes/CompositeView.schelp block 0 (part 1/3)
(
w = Window.new;

c = CompositeView(w, Rect(50, 0, 300, 300));
a = Slider2D(c, Rect(0, 0, 100, 100)); // actually displays at (50, 0)
b = Slider2D(c, Rect(100, 100, 100, 100));

c.background = Color.rand;

w.front;
)
