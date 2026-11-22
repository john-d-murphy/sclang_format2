// Source: Classes/Routine.schelp block 12
(
var r;
r = Routine {
	10.do({ |a|
		a.postln;
		// Often you might see Wait being used to pause a routine
		// This waits for one second between each number
		1.wait;
	});
	// Wait half second before saying we're done
	0.5.wait;
	"done".postln;
}.play;
)
