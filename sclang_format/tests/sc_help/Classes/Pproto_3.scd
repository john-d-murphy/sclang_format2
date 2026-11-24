// Source: Classes/Pproto.schelp block 3
(
SynthDef(\echo, { |out = 0, maxdtime = 0.2, dtime = 0.2, decay = 2, gate = 1|
	var env, in;
	env = Linen.kr(gate, 0.05, 1, 5, 2);
	in = In.ar(out, 2);
	XOut.ar(out, env, CombL.ar(in * env, maxdtime, Lag.kr(dtime, 4), decay, 1, in));
}, [\ir, \ir, 0.1, 0.1, 0]).add;

SynthDef(\fm, { |out = 0, freq, index, decay = 2, gate = 1|
	var env, in;
	env = Linen.kr(gate, 0.05, 1, 5, 2);
	in = In.ar(out, 2);
	XOut.ar(out, env, SinOsc.ar(freq, in * index));
}).add;

Pproto({
	// start two effect synths (just switching them on) and store the parameters in the environment
	~fsynth = (type: \on, instrument: \fm, freq: 4, index: 1, addAction: 1, db: -30).yield;
	~fControl = [\set, ~fsynth[\id], ~fsynth[\msgFunc]];

	~synth = (type: \on, instrument: \echo, addAction: 1).yield;
	~sControl = [\set, ~synth[\id], ~synth[\msgFunc]];

	}, [
	Pbind(*[
		#[type, id, msgFunc],	Pkey(\fControl), // fetch the parameters from the environment

		freq:	Pseg([0, 1], 10).linexp(0, 1, 0.1, 1000),
		index:	Pseg([0, 1], 10).linexp(0, 1, 0.1, 100),
		dur:	0.1
	]),
	Pbind(*[
		#[type, id, msgFunc],	Pkey(\sControl), // fetch the parameters from the environment

		dtime:	Pwhite(0, 0.2),
		decay:	Pwhite(0.1, 2),
		dur:	1
	]),
	Pbind(*[
		instrument: \default,
		freq: Pwhite(1, 16) * 100,
		dur: 0.2,
		db:	0
	])
	]
).play
)
