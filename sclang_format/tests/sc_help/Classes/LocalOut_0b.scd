// Source: Classes/LocalOut.schelp block 0 (part 2/4)
(
z = SynthDef("tank", { |out|
	var local, in;

	in = Mix.fill(12, {
		Pan2.ar(
			Decay2.ar(Dust.ar(0.05), 0.1, 0.5, 0.1)
				* FSinOsc.ar(IRand(36,84).midicps).cubed.max(0),
			Rand(-1,1))
	});
	in = in + Pan2.ar(Decay2.ar(Dust.ar(0.03), 0.04, 0.3) * BrownNoise.ar, 0);

	4.do { in = AllpassN.ar(in, 0.03, {Rand(0.005,0.02)}.dup, 1); };

	local = LocalIn.ar(2) * 0.98;
	local = OnePole.ar(local, 0.5);

	local = Rotate2.ar(local[0], local[1], 0.23);
	local = AllpassN.ar(local, 0.05, {Rand(0.01,0.05)}.dup, 2);

	local = DelayN.ar(local, 0.3, [0.19,0.26]);
	local = AllpassN.ar(local, 0.05, {Rand(0.03,0.15)}.dup, 2);

	local = LeakDC.ar(local);
	local = local + in;

	LocalOut.ar(local);

	Out.ar(out, local);
}).play;
)
