// Source: Classes/Stepper.schelp block 0 (part 9/16)
(
SynthDef(\stepper, { |out|
	var rate, clock, index, freq, ffreq, env, out, rev, lfo;

	rate = MouseX.kr(1,5,1);
	clock = Impulse.kr(rate);
	env = Decay2.kr(clock, 0.002, 2.5);
	index = Stepper.kr(clock, 0, 0, 15, 1, 0);
	freq = BufRd.kr(1, 10, index, 1, 1);
	freq = Lag2.kr(freq) + [0,0.3];
	ffreq = MouseY.kr(80,1600,1) * (env * 4 + 2);
	out = Mix.ar(LFPulse.ar(freq * [1, 3/2, 2], 0, 0.3));
	out = RLPF.ar(out, ffreq, 0.3, env);
	out = RLPF.ar(out, ffreq, 0.3, env);
	out = out * 0.02;

	// echo
	out = CombL.ar(out, 1, 0.66/rate, 2, 0.8, out);

	// reverb
	rev = out;
	5.do { rev = AllpassN.ar(rev, 0.05, { 0.05.rand }.dup, rrand(1.5,2.0)) };
	out = out + (0.3 * rev);

	out = LeakDC.ar(out);

	// flanger
	lfo = SinOsc.kr(0.2, [0,0.5pi], 0.0024, 0.0025);
	1.do { out = DelayL.ar(out, 0.1, lfo, 1, out) };

	// slight bass emphasis
	out = OnePole.ar(out, 0.9);

	Out.ar(out, out);

}).add;
)
