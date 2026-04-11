// Source: Classes/Slider.schelp block 6
(
w = Window("RGB fader", Rect(100, 500, 400, 400))
	.front;
f = { w.view.background_(Color.new(r.value, g.value, b.value, 1)) };
r = Slider(w, Rect(100, 140, 200, 20))
	.value_(0.5)
	.action_({ f.value });
g = Slider(w, Rect(100, 170, 200, 20))
	.value_(0.5)
	.action_({ f.value });
b = Slider(w, Rect(100, 200, 200, 20))
	.value_(0.5)
	.action_({ f.value });
f.value;
);
