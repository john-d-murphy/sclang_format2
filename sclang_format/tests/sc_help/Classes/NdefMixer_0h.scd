// Source: Classes/NdefMixer.schelp block 0 (part 8/14)
(
Ndef(\aaaaaa, { |freq = 250, intv = 19, timescale = 1, curve = 0, loopnode = 0|
	var env = EnvGen.kr(
		Env({ 1.0.rand2 }!11, { 1.0.rand }!10, curve, releaseNode: 9, loopNode: loopnode),
		timeScale: timescale);
	var pitch = (env * [1, 0.33, -1] * intv).midiratio * freq;
	Splay.ar(Formant.ar(pitch, pitch.scramble * 2, pitch.scramble)) * 0.1;
}).play(vol: 0.25);
)
