// Source: Classes/Node.schelp block 14 (part 1/2)
(
SynthDef(\help, { |out|
	var mod = LFNoise2.kr(Rand(1, 6)) * 0.2;
	var snd = mod * Blip.ar(Rand(200, 800) * (mod + 1));
	Out.ar(out, snd);
	FreeSelf.kr(mod < 0);
}).add;
)
