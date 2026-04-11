// Source: Classes/SelectXFocus.schelp block 2 (part 1/2)
(
{
	var a, n, mx, my, mwrap;
	n = 8;
	mx = MouseX.kr(0, 1, 0, 0.1);
	my = MouseY.kr;
	mwrap = { |pmin, pmax, min, max| sin(mx * ExpRand(pmin, pmax)) + 1 * 0.5 * ExpRand(min, max) };
	a = {
		var freq, fmul, phase;
		freq = mwrap.(10, 40, 200, 5000) + ExpRand(200, 3000);
		fmul = LFNoise0.kr(ExpRand(0.1, 8)).round(1/6).exprange(1, Rand(1, 1.2));
		phase = LFNoise2.ar(mwrap.(1, 20, 10, 1000), Rand(2, 5));
		SinOsc.ar(freq * fmul, phase)
	} ! n;
	a = a.add(
		SinOsc.ar(LFDNoise0.kr(11, SetResetFF.kr(*Dust.kr([1, 2] * 0.3))).range(0, 700) + 220)
	);
	SelectXFocus.ar(mx * n, a, my * n) * 0.2 + OnePole.ar(PinkNoise.ar(0.5 ! 2), 0.4)
	* Line.kr(0, 1, 3);
}.play;
)
