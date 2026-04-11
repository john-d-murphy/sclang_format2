// Source: Classes/HiliteGradient.schelp block 0 (part 4/4)
(
var w, k, c, d, e, c1, c2, f, g;
w = Window.new.front;
k = Slider2D(w, Rect(50, 50, 300, 300));
f = {
	c = Color.rand;
	d = c.vary(0.5);
	e = d.vary(0.5);
};
g = {
	c1 = d.hueBlend(e, k.y).round(0.01);
	c2 = c.hueBlend(e, k.x).round(0.01);
	k.background = HiliteGradient(c1, c2, \v)
};
f.value; g.value;
k.action = g;
k.mouseUpAction = { [c1, c2].postln };
k.keyDownAction = f; // hit any key for new color
)
