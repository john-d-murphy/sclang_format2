// Source: Classes/Osc.schelp block 0 (part 1/6)
(
s = Server.local;
b = Buffer.alloc(s, 512, 1);
b.sine1(1.0/[1,2,3,4,5,6], true, true, true);

SynthDef("help-Osc",{ arg out=0,bufnum=0;
	Out.ar(out,
		Osc.ar(bufnum, 200, 0, 0.5)
	)
}).play(s,[\out, 0, \bufnum, b.bufnum]);
)
