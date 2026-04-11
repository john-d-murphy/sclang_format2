// Source: Classes/ModDif.schelp block 1 (part 1/2)
(
{
	var sig = LFSaw.ar(10);
	var dist = ModDif.kr(sig, 0, (0..8) * MouseX.kr(0, 1/5));
	Splay.ar(SinOsc.ar(dist * 4000 + 400)) * 0.1
}.play;
)
