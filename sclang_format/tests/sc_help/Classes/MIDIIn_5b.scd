// Source: Classes/MIDIIn.schelp block 5 (part 2/6)
(
SynthDef("funk",{ | out, freq = 700, amp = 0.2, gate = 1, cutoff = 20000, rez = 1, lfospeed = 0 |
	var e, x, env, range, filterfreq;
	e = Env.new([0, 0.1, 0.1, 0], [0, 0.1, 0.1], 'linear', 2);
	env = Env.adsr(0.3,1,1,1);
	range = cutoff -1;
	filterfreq = SinOsc.kr(lfospeed,0, range, cutoff).abs;
	x = RLPF.ar(Mix.ar([
			Mix.arFill(2, {Saw.ar(freq *2 + 0.2.rand2, amp)}),
			Mix.arFill(2, {Saw.ar(freq *4+ 0.2.rand2, amp)})
		]),
		EnvGen.kr(env,gate)*filterfreq,
		rez);
	Out.ar(out, x * EnvGen.kr(e, gate, doneAction: Done.freeSelf))
}).add;

SynthDef("strings", { |out, freq = 700, amp = 0.2, gate = 1|
	var x, enve;
	enve = Env.new([0, 0.1, 0.1, 0], [2, 0.1, 1], 'linear', 2);
	x = RLPF.ar(Mix.ar([
			Mix.arFill(2, {Saw.ar(freq +2.rand2,0.6)}),
			Mix.arFill(2, {Saw.ar(freq *0.5 + 2.rand2,0.6)})
		]),
		6000,1);
	Out.ar(out, x * EnvGen.kr(enve, gate, doneAction: Done.freeSelf))
}).add;
)
