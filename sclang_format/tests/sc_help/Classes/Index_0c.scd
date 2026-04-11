// Source: Classes/Index.schelp block 0 (part 3/6)
(
// indexing into a changeable table
s = Server.local;
t = [ 200, 300, 400, 500, 600, 800 ];
b = Buffer(s, t.size, 1);

// alloc and set the values
s.listSendMsg( b.allocMsg( b.setnMsg(0, t) ).postln );

SynthDef(\help_Index, { |out = 0, bufnum = 0|
	Out.ar(out,
		SinOsc.ar(
			Index.kr(
				bufnum,
				LFSaw.kr(2).range(0, 7)
			),
			0,
			0.5
		)
	)
}).play(s, [\bufnum, b]);
)
