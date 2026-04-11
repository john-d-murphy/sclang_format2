// Source: Classes/Slider.schelp block 2
(
w = Window.new.front;
a = ["0", "0.0625", "0.125", "0.25", "0.5", "1"];
b = Slider(w, Rect(20, 100, 100, 20))
	.action_({
		c.value_(b.value)
		}).background_(Color.rand);
d = PopUpMenu(w, Rect(20, 60, 100, 20))
	.items_(a)
	.action_({
		b.step_((a.at(d.value)).asFloat);
	});
StaticText(w, Rect(130, 60, 100, 20)).string_("change step");
c = NumberBox(w, Rect(20, 20, 100, 20));
)
