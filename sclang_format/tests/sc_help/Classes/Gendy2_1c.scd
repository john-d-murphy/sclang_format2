// Source: Classes/Gendy2.schelp block 1 (part 3/18)
(
{ 
	Pan2.ar(
		Normalizer.ar(
			RLPF.ar(
				RLPF.ar(
					Gendy2.ar(
						a: SinOsc.kr(0.4, 0, 0.05, 0.05), 
						c: SinOsc.kr(0.3, 0, 0.1, 0.5)
					), MouseX.kr(10, 10000, 'exponential'), 0.05
				), MouseY.kr(10, 10000, 'exponential'), 0.05
			), 0.9
		), Lag.kr(LFNoise0.kr(1), 0.5)
	)
}.play
)
