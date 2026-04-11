// Source: Classes/Slider.schelp block 0 (part 2/2)
( // change the bounds to become vertical
w = Window.new.front;
c = NumberBox(w, Rect(20, 20, 150, 20));
a = Slider(w, Rect(200, 60, 20, 150))
	.action_({
		c.value_(a.value)
	});
a.action.value;
)
