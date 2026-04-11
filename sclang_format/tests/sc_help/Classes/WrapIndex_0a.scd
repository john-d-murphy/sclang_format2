// Source: Classes/WrapIndex.schelp block 0 (part 1/2)
(
{
	var buf = LocalBuf.newFrom([ 200, 300, 400, 500, 600, 800 ]);
	var freq = WrapIndex.kr(buf, MouseX.kr(0, BufFrames.ir(buf) * 3));
	SinOsc.ar(freq) * 0.1
}.play;
)
