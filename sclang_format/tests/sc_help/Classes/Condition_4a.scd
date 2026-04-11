// Source: Classes/Condition.schelp block 4 (part 1/2)
(
SynthDef(\help, { |out|
	var mod = LFNoise2.kr(ExpRand(0.5, 2)) * 0.5;
	var snd =  mod * Blip.ar(Rand(200, 800) * (mod + 1));
	Out.ar(out, snd);
	FreeSelf.kr(mod < 0); // free the synth when amplitude goes below 0.
}).add;
)
