// Source: Classes/EnvGen.schelp block 10
(
Slider(nil, Rect(800, 200, 200, 25))
.action_({ |view| z.set(\atk, view.value.lincurve(0, 1, 0, 0.12, 4)) })
.front
.onClose_({ z.free });

z = SynthDef(\test, { |out = 0, freq = 100, ffreq = 500, rq = 0.25, modFactor = 12, atk = 0, dcy = 0.12|
	var trig = Impulse.kr(1);
	var filtEg = EnvGen.kr(Env([0, 1, 0], [atk, dcy], -4), trig);
	var ampEnvDelay = max(0, (0.05 - atk) * 0.1);
	var ampEg = EnvGen.ar(Env.linen(0.001, 0.2, 0.1), TDelay.kr(trig, ampEnvDelay));
	var sig = Saw.ar(freq);
	ffreq = ffreq * (1 + (filtEg * modFactor));
	sig = BLowPass4.ar(sig, ffreq, rq) * ampEg;
	Out.ar(out, (sig * 0.1).dup)
}).play;
)
