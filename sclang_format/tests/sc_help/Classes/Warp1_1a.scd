// Source: Classes/Warp1.schelp block 1 (part 1/2)
(
b.free;
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");
{
	var pointer = Phasor.ar(0, SampleDur.ir / BufDur.ir(b) * XLine.kr(1, 0.25, 20));
	var sound = Warp1.ar(1, b, pointer, 1, 0.3, -1, 16, Line.kr(0, 1, 40), 4);
	Pan2.ar(sound, pointer * 2 - 1, 0.25)
}.play
)
