// Source: Classes/Osc.schelp block 0 (part 5/6)
(
// change the buffer while its playing
s = Server.local;
b = Buffer.alloc(s, 4096, 1);
b.sine1(1.0/[1,2,3,4,5,6], true, true, true);

SynthDef("help-Osc",{ arg out=0,bufnum=0;
	Out.ar(out,
		Osc.ar(bufnum, [80,80.2], 0, 0.2)
	)
}).play(s,[\out, 0, \bufnum, b.bufnum]);
)
