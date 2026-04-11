// Source: Classes/PatternConductor.schelp block 0 (part 1/9)
(
// a pattern with long notes
p = Pbind(
	\freq, Pwhite(0,log(32)).exp.round(1) * 36.midicps,
	\detune, Pfunc({ | ev | ev[\freq]  * rand(0.01) }),
	\sustain, Pwhite(log(0.1), log(20)).exp,
	\dur, Prand([0.1,0.1,0.1,0.1,0.2,1,2],inf),
	\db, Pstep(Pseq([-20,-30,-25,-30], inf),0.2)
);

// unrelated cluster pattern running on TempoClock.default
Pbind(\dur,2, \midinote, Pseq([(48..60)],20), \db, -30).play;

// make a conductor
a = PatternConductor(p, quant: 2);
a.play;
)
