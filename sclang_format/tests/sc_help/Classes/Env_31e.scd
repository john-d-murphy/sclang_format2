// Source: Classes/Env.schelp block 31 (part 5/7)
(
Task({
	f = (0, 0.2 .. 1);
	f.do { |u|
		blend(a, b, u).test.plot;
		2.wait;
		Window.allWindows.pop.close; // close last opened window
	}
}).play(AppClock);
)
