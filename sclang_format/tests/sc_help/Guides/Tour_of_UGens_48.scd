// Source: Guides/Tour_of_UGens.schelp block 48
(
{
	// rotation of stereo sound via mouse
	var x, y;
	x = Mix.fill(4, { LFSaw.ar(200 + 2.0.rand2, 0, 0.1) }); // left in
	y = WhiteNoise.ar * LFPulse.kr(3,0,0.7,0.2); // right in
	#x, y = Rotate2.ar(x, y, MouseX.kr(0,2));
	[x,y]
}.scope(2);
)
