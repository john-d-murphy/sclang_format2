// Source: Classes/Rotate2.schelp block 2 (part 3/12)
{
	// rotation via mouse
	var x, y;
	x = Mix.fill(4, { LFSaw.ar(200 + 2.0.rand2, 0, 0.1) });
	y = SinOsc.ar(900) * LFPulse.kr(3,0,0.3,0.2);
	#x, y = Rotate2.ar(x, y, MouseX.kr(0,2));
	[x,y]
}.play;
