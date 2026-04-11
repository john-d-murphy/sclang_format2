// Source: Classes/NodeProxy.schelp block 7 (part 2/2)
(
Ndef(\sound, { |fadeTime = 1, gate = 1|
	var e = Env.adsr(fadeTime, 0.01, 0.4, fadeTime).ar(2, gate);
	SinOsc.ar(100 + (e * 700), SinOsc.ar(208) * (1 - e) * 6) * e * 0.1
}).play
)
