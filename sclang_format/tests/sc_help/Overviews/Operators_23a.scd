// Source: Overviews/Operators.schelp block 23 (part 1/2)
(
{ // trigger an envelope
	var trig;
	trig = SinOsc.ar(1) > 0;
	EnvGen.kr(Env.perc, trig, doneAction: Done.none)
			* SinOsc.ar(440, 0, 0.1)
}.play
)
