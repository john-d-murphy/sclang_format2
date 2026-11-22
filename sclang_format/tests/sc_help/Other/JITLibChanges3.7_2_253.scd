// Source: Other/JITLibChanges3.7.schelp block 2 (part 254/815)
(
c = Ndef(\x).clock ? TempoClock.default;
c.sched(c.timeToNextBeat(4, 0.1), {
	Ndef(\x, { DC.ar([0, 0, 0]) }); (Ndef(\y).bus != b).postln; (b.index != nil).postln;

});
fork { 1.wait; c.sched(c.timeToNextBeat(4), { c.sched(Ndef(\x).fadeTime, { (b.index == nil).postln; nil }); nil }) };
);
