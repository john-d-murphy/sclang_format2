// Source: Classes/FreqShift.schelp block 1 (part 2/6)
(
r = Routine({
	var table,pitch;
	table = [0,2,4,5,7,9,11,12];
	inf.do {
		pitch = (48+(12*2.rand) + table.choose).midicps;
		Synth.grain(\frqShift1, [\freq, pitch]);
		3.wait;
	};
}).play;
)
