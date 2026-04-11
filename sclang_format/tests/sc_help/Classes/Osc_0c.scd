// Source: Classes/Osc.schelp block 0 (part 3/6)
(
s = Server.local;
b = Buffer.alloc(s, 512, 1);
b.sine1([1.0], true, true, true);

SynthDef("help-Osc",{ arg out=0,bufnum=0;
	Out.ar(out,
		Osc.ar(bufnum,
			Osc.ar(bufnum,
				XLine.kr(1,1000,9),
				0,
				200,
				800),
			0,
			0.25)
	)
}).play(s,[\out, 0, \bufnum, b.bufnum]);
)
