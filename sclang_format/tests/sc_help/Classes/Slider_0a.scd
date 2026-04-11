// Source: Classes/Slider.schelp block 0 (part 1/2)
(
w = Window.new.front;
c = NumberBox(w, Rect(20, 20, 150, 20));
a = Slider(w, Rect(20, 60, 150, 20))
	.action_({
		c.value_(a.value)
		});
a.action.value;
)
