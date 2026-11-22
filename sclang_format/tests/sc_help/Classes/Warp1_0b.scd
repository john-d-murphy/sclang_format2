// Source: Classes/Warp1.schelp block 0 (part 2/6)
(
b = Buffer.read(s, ExampleFiles.apollo11);
x = { |envbuf = -1|
	var pointer, pitch;
	// pointer - move from beginning to end of soundfile over 15 seconds
	pointer = LFSaw.ar(1/15).range(0, 1);
	// control pitch with MouseX
	pitch = MouseX.kr(0.5, 2);
	Warp1.ar(
		numChannels: 1,
		bufnum: b,
		pointer: pointer,
		freqScale: pitch,
		windowSize: 0.1,
		envbufnum: envbuf,
		overlaps: 8,
		windowRandRatio: 0.1,
		interp: 2
	)
}.play

)
