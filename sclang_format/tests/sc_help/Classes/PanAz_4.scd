// Source: Classes/PanAz.schelp block 4
(
{
	PanAz.ar(
		numChans: 5,
		in: ClipNoise.ar(0.1),
		pos: LFSaw.kr(MouseX.kr(0.2, 8, 'exponential')),
		level: 0.5,
		width: 3,
		orientation: 0.5
	);
}.scope
)
