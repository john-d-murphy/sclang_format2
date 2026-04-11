// Source: Classes/Pattern.schelp block 6 (part 2/2)
(
SynthDef(\cfstring1, { arg i_out, freq = 360, gate = 1, pan, amp=0.1;
	var out, eg, fc, osc, a, b, w;
	fc = LinExp.kr(LFNoise1.kr(Rand(0.25, 0.4)), -1, 1, 500, 2000);
	osc = Mix.fill(8, {LFSaw.ar(freq * [Rand(0.99, 1.01), Rand(0.99, 1.01)], 0, amp) }).distort * 0.2;
	eg = EnvGen.kr(Env.asr(1, 1, 1), gate, doneAction: Done.freeSelf);
	out = eg * RLPF.ar(osc, fc, 0.1);
	#a, b = out;
	Out.ar(i_out, Mix.ar(PanAz.ar(4, [a, b], [pan, pan+0.3])));
}).add;

SynthDef("sinegrain2",
	{ arg out=0, freq=440, sustain=0.05, pan;
		var env;
		env = EnvGen.kr(Env.perc(0.01, sustain, 0.3), doneAction: Done.freeSelf);
		Out.ar(out, Pan2.ar(SinOsc.ar(freq, 0, env), pan))
	}).add;

p = Pbind(
	[\degree, \dur], Pseq([[0, 0.1], [2, 0.1], [3, 0.1], [4, 0.1], [5, 0.8]], 1),
	\amp, 0.05, \octave, 6, \instrument, \cfstring1, \mtranspose, 0);

q = Pbindf(p, \instrument, \default );

r = Pset(\freq, Pseq([500, 600, 700], 2), q);

)
