// Source: Classes/Routine.schelp block 13
(
var r;
r = Routine {
	var times = { rrand(1.0, 10.0) }.dup(10) + thisThread.beats;
	times = times.sort;
	times.do({ |a|
		waitUntil(a);
		a.postln;
	});
	// Wait half second before saying we're done
	0.5.wait;
	"done".postln;
}.play;
)
