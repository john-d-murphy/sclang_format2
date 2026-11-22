// Source: Classes/PstepNadd.schelp block 0 (part 2/8)
(
x = PstepNadd(
		Plazy({ "pattern1.asStream".postln; Pseq([1, 2, 3], 2) }),
		Plazy({ "pattern2.asStream".postln; Pshuf([10, 20, 30, 40]) }),
		Plazy({ "pattern3.asStream".postln; Pseq([100, 200, 300]) }),
		Plazy({  Pseries(1, 1, 4) * 0.01 })
	).asStream;
150.do({ x.next.postln });
)
