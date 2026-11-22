// Source: Classes/Gradient.schelp block 0 (part 5/5)
(
w = Window.new.front;
g = Gradient(Color.red, Color.green);
Task{
	(0, 0.01 .. 1).do{ |pos|
		w.view.background = g.at(pos);
		0.01.wait;
	};
}.play(AppClock)
)
