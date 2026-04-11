// Source: Classes/Osc.schelp block 0 (part 4/6)
(
// modulate phase
s = Server.local;
b = Buffer.alloc(s, 512, 1);
b.sine1([1.0], true, true, true);

SynthDef("help-Osc",{ arg out=0,bufnum=0;
	Out.ar(out,
		Osc.ar(bufnum,
				800,
				Osc.ar(bufnum,
						XLine.kr(20,8000,10),
						0,
						2pi),
				0.25)
	)
}).play(s,[\out, 0, \bufnum, b.bufnum]);
)
