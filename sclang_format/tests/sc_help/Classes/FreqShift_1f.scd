// Source: Classes/FreqShift.schelp block 1 (part 6/6)
(
r = Routine({
	var table, pitch;
	table = [0,2,4,5,7,9,11,12];
	inf.do{
		pitch = (48+(12*2.rand) + table.choose).midicps;
		s.sendMsg(\s_new, \frqShift1, -1, 1, 1, \freq, pitch, \bufnum, 99);
		3.wait;
		};
	}).play
)
