// Source: Reference/softPut.schelp block 0 (part 1/11)
(
e = (amp: 0.1, dur: 0.2);
Tdef(\test, {
	var dur;
	loop {
		dur = e.dur;
		(amp: e.amp, dur: dur, degree: 7.rand).play;
		dur.wait;
	};
}).play;
)
