// Source: Classes/InFeedback.schelp block 2
(
var play, imp, initial;
SynthDef("testRes", {

play = InFeedback.ar(10, 1); // 10 is feedback channel
imp = Impulse.ar(1);

// feedback
OffsetOut.ar(10, DelayC.ar(imp + (play * 0.995), 1,
	440.reciprocal - ControlRate.ir.reciprocal)); // subtract block size

OffsetOut.ar(0, play);

}).play(s);

// Compare with this for tuning
{ SinOsc.ar(440, 0, 0.2) }.play(s, 1);
)
