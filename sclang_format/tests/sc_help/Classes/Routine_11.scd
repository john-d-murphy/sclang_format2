// Source: Classes/Routine.schelp block 11
(
var r, outval;
r = Routine.new({ arg inval;
	("->inval was " ++ inval).postln;
	inval = 1.yield;
	("->inval was " ++ inval).postln;
	inval = 2.yield;
	("->inval was " ++ inval).postln;
	inval = 99.yield;
});

outval = r.next('a');
("<-outval was " ++ outval).postln;
outval = r.next('b');
("<-outval was " ++ outval).postln;
r.reset; "reset".postln;
outval = r.next('c');
("<-outval was " ++ outval).postln;
outval = r.next('d');
("<-outval was " ++ outval).postln;
outval = r.next('e');
("<-outval was " ++ outval).postln;
outval = r.next('f');
("<-outval was " ++ outval).postln;
)
