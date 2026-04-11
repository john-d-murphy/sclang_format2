// Source: Classes/Button.schelp block 0
(
w = Window.new("The Four Noble Truths");

b = Button(w, Rect(20, 20, 340, 30))
		.states_([
			["there is suffering", Color.black, Color.red],
			["the origin of suffering", Color.white, Color.black],
			["the cessation of suffering", Color.red, Color.white],
			["there is a path to cessation of suffering", Color.blue, Color.clear]
		])
		.action_({ arg butt;
			butt.value.postln;
		});
w.front;
)
