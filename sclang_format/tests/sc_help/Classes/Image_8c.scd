// Source: Classes/Image.schelp block 8 (part 3/4)
(
	w = Window.new.front;
	b = [10, 80].asSpec;
	c = NumberBox(w, Rect(20, 20, 60, 40));
	a = Slider(w, Rect(20, 80, 100, 40))
		.focusColor_(Color.red(alpha: 0.2))
		.action_({
			c.value_(b.map(a.value).round(0.01))
	// round the float so it will fit in the NumberBox
			});
)
