// Source: Classes/Slider.schelp block 1
(
w = Window.new.front;
b = ControlSpec(-50, 50, \linear, 0.01); // min, max, mapping, step
c = StaticText(w, Rect(20, 20, 150, 20)).align_(\center).background_(Color.rand);
a = Slider(w, Rect(20, 50, 150, 20))
	.focusColor_(Color.red(alpha: 0.2))
	.background_(Color.rand)
	.value_(0.5)
	.action_({
		c.string_(b.map(a.value).asString)
		// round the float so it will fit in the NumberBox
		});
a.action.value;
)
