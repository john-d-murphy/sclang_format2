// Source: Classes/LatoocarfianL.schelp block 3
(
{ LatoocarfianL.ar(
	SampleRate.ir/4,
	[LFDNoise0,LFClipNoise,LFDNoise1,LFDNoise3,
		LFNoise0,LFNoise1,LFNoise2].choose.kr(rrand(2,20),rrand(2,20)*0.1,rrand(2,20)*0.2),
		[LFDNoise0,LFClipNoise,LFDNoise1,LFDNoise3,
		LFNoise0,LFNoise1,LFNoise2].choose.kr(rrand(2,20),rrand(2,20)*0.1,rrand(2,20)*0.2),
		[LFDNoise0,LFClipNoise,LFDNoise1,LFDNoise3,
		LFNoise0,LFNoise1,LFNoise2].choose.kr(rrand(2,20),rrand(2,20)*0.1,rrand(2,20)*0.2),
		[LFDNoise0,LFClipNoise,LFDNoise1,LFDNoise3,
		LFNoise0,LFNoise1,LFNoise2].choose.kr(rrand(2,20),rrand(2,20)*0.1,rrand(2,20)*0.2)
) * 0.2 !2}.play;
)
