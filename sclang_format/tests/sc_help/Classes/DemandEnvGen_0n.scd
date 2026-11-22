// Source: Classes/DemandEnvGen.schelp block 0 (part 14/18)
(
	{

			DemandEnvGen.ar(
				Dseq([Dseries(-0.1, 0.01, 20)], inf),
				SampleDur.ir * MouseY.kr(1, 100, 1),
				1, 0,
				K2A.ar(1),
				Impulse.ar(MouseX.kr(1, SampleRate.ir * MouseX.kr(0.002, 1, 1), 1), 0, 1.5)

			)


	}.scope;
)
