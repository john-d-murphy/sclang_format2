// Source: Classes/Pseed.schelp block 1 (part 16/20)
(
SynthDef.new(\varsaw, {
	arg dur, attack = 0.01, release = 1.0,
	t_gate = 1, out, freq = 442, cutoff = 5500,
	rq = 1, pan = 0.0, amp = 0.5, width = 0.1;

	var env = EnvGen.kr(Env.perc(attack, release), t_gate, timeScale: dur, doneAction: 2);
	var sig = VarSaw.ar(freq: freq, mul: env, width: width);
	sig = RLPF.ar(sig, cutoff.clip(20.0, 20000.0), rq.clip(0.0, 1.0));
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig * amp);
}).add;
)
