// Source: Classes/DemandEnvGen.schelp block 0 (part 12/18)
(
	{
			DemandEnvGen.ar(
				Dwhite(-0.1, 0.1, inf),
				SampleDur.ir * MouseY.kr(0.5, 20),
				5,
				-4
			);


	}.play;
)
