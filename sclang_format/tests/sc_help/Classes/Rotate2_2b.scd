// Source: Classes/Rotate2.schelp block 2 (part 2/12)
(
{
	// rotation via lfo
	var x, y;
	x = PinkNoise.ar(0.4);
	y = LFTri.ar(800) * LFPulse.kr(3,0,0.3,0.2);
	#x, y = Rotate2.ar(x, y, LFSaw.kr(0.1));
	[x,y]
}.play;
)
