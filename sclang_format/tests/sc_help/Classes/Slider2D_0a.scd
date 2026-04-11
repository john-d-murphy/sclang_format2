// Source: Classes/Slider2D.schelp block 0 (part 1/2)
(
w = Window("Slider2D", Rect(100, 100, 140, 140));
t = Slider2D(w, Rect(20, 20, 80, 80))
		.x_(0.5) // initial location of x
		.y_(1)   // initial location of y
		.action_({|sl|
			[\sliderX, sl.x, \sliderY, sl.y].postln;
		});
w.front;
)
