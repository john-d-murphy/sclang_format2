// Source: Classes/Stream.schelp block 4 (part 2/3)
(
SystemClock.sched(0.0,
	Routine({ loop {
		"***".postln; 0.5.yield;
		"_*_".postln; 0.1.yield;
	} });
);
)
