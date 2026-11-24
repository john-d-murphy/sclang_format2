// Source: Classes/Scheduler.schelp block 1 (part 1/10)
(
x = Scheduler(TempoClock.default);

Task {
	inf.do { |i|
		("next " ++ i ++ " in task." + Main.elapsedTime).postln;
		0.5.wait;
	}
}.play(x);
)
