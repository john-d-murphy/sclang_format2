// Source: Classes/Pseed.schelp block 1 (part 18/20)
(
SynthDef(\drum, { |out, dur, t_gate = 1, pew = 1, sustain = 1, pan, fed = 0, tun, amp = 1|
	var env, freq, sig;
	tun = ((tun>0)*tun) + ((tun<1)*3);
	freq = (tun*10).midicps;
	env = EnvGen.ar(Env.linen(0.01, 0, 1, 1, -3), t_gate, timeScale: dur, doneAction: 2);
	sig = LPF.ar(SinOscFB.ar(XLine.ar(freq.expexp(10, 2000, 1000, 8000), freq, 0.025/pew), fed), 9000);
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig * amp);
}).add
)
