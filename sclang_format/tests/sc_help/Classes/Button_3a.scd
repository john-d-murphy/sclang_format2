// Source: Classes/Button.schelp block 3 (part 1/5)
(
w = Window.new("Example");

b = Button(w, Rect(90, 20, 200, 30))
		.states_([
			["sine", Color.black, Color.rand],
			["saw", Color.black, Color.rand],
			["noise", Color.black, Color.rand],
			["pulse", Color.black, Color.rand]
		])
		.action_({ arg butt;
			butt.value.postln;
		});
w.front;
)
