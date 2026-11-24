// Source: Classes/Tdef.schelp block 4 (part 1/8)
(
Tdef(\a, { "one".postln; 1.wait; "two".postln });
Tdef(\c, { var z; z = Synth(\default); 0.5.wait; z.release });
r = Task({
	"counting...".postln;
	2.wait;
	Tdef(\a).embed;
	1.wait;
	Tdef(\c).embed;
	"done.".postln;
});
)
