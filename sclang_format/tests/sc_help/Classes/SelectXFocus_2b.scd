// Source: Classes/SelectXFocus.schelp block 2 (part 2/2)
(
{
	var blas, zieh, mx, my, trig, which, amp, u, schnauf;
	var del = 9, det = 0.1;
	schnauf = 0.3;
	mx = MouseX.kr;
	my = MouseY.kr(0.1, 2, 1);

	blas = [0, 12, 24] +.x [60, 64, 67] ++ [60+36];
	zieh = [62, 67, 71,   74, 77, 81, 83,   86, 89, 93];

	trig = Dust.kr(1);
	which = ToggleFF.kr(TDelay.kr(trig, schnauf));
	amp = EnvGen.kr(Env([1, 0, 1], [schnauf, schnauf]), trig);
	blas = Select.kr(which, [blas, zieh]);
	u = SelectXFocus.ar(
		mx * blas.size,
		blas.collect {|f|
			Pulse.ar((Rand(-0.04, 0.09) + f).midicps * 0.5, 0.48 + LFNoise1.kr(0.06, 0.1), 0.2)
		},
		my
	) * Slope.kr(mx + my).abs.lag2(2) * amp;
	u = Pan2.ar(OnePole.ar(u, -0.3), mx * 2 - 1);
	DelayL.ar(BPF.ar(u * 2, 1500, 0.3), del + det, LFNoise2.kr(0.2, det, del)) + u
}.play;
);
