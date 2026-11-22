// Source: Classes/Gendy1.schelp block 0 (part 13/18)
(
		{ 
			Pan2.ar(Gendy1.ar(6, 6, LFPulse.kr(MouseX.kr(0, 200), 0, 0.4, 1.0),
			SinOsc.kr(MouseY.kr(0, 200), 0, 0.5), mul: 0.2), 0.0)
		}.play
	)
