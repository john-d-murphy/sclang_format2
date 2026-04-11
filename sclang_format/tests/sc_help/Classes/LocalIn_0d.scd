// Source: Classes/LocalIn.schelp block 0 (part 4/4)
(
{
	var in, imp, sound;

	in = LocalIn.ar(1);
	imp = Impulse.ar(1);
	sound = DelayC.ar(imp + (in * 0.995), 1, 440.reciprocal - ControlRate.ir.reciprocal);
	LocalOut.ar(sound); // for feedback
	in
}.play;

// compare pitch
{
	SinOsc.ar(440, 0, 0.2)
}.play(s, 1);
)
