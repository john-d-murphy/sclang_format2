// Source: Classes/LocalOut.schelp block 0 (part 4/4)
(

{
	var imp, local;
	local = LocalIn.ar(1);
	imp = Impulse.ar(1);

	// for feedback
	LocalOut.ar(DelayC.ar(imp + (local * 0.995), 1, 440.reciprocal - ControlRate.ir.reciprocal));

	local

}.play;

{ SinOsc.ar(440, 0, 0.2) }.play; // compare pitch
)
