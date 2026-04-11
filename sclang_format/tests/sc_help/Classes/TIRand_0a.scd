// Source: Classes/TIRand.schelp block 0 (part 1/3)
(
SynthDef("help-TIRand", {
	var trig, outBus;
	trig = Dust.kr(10);
	outBus = TIRand.kr(0, 1, trig); //play on random channel between 0 and 1
	Out.ar(outBus, PinkNoise.ar(0.2))

}).play;
)
